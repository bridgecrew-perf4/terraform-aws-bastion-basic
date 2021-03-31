data "aws_ami" "amazon_2_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "bastion_instance" {
  ami                         = data.aws_ami.amazon_2_ami.id
  instance_type               = "t3a.micro"
  key_name                    = var.bastion_instance_key
  vpc_security_group_ids      = [aws_security_group.bastion_security_group.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data                   = <<-EOF
#!/usr/bin/env bash
yum update -y
EOF

  root_block_device {
    encrypted = true
  }

  tags = merge({ Name = "bastion-demo", Service = "Bastion" }, local.tags)
}

resource "aws_security_group" "bastion_security_group" {
  name        = "bastion-security-group-demo"
  description = "Bastion security group to allow ssh access to private instances"
  vpc_id      = var.vpc_id

  tags = merge({ Name = "bastion-security-group-demo" }, local.tags)
}

resource "aws_security_group_rule" "bastion_security_group_rule_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_security_group.id
  description       = "Allow ssh traffic from anywhere"
}

resource "aws_security_group_rule" "bastion_security_group_rule_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_security_group.id
  description       = "Allow all traffic out"
}