output "bastion_instance_id" {
  description = "The AWS Instance ID of the Bastion Instance"
  value       = aws_instance.bastion_instance.id
}

output "bastion_instance_arn" {
  description = "The ARN of the Bastion instance"
  value       = aws_instance.bastion_instance.arn
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion_security_group.id
}

output "bastion_security_group_arn" {
  value = aws_security_group.bastion_security_group.arn
}