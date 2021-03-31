variable "environment" {
  description = "The defining environment of the Account: DEV, TST, STG, PRD, ROOT"
  type        = string
  default     = "demo"
}

variable "vpc_id" {
  type        = string
  description = "Desired VPC ID for Instance Creation"
  default     = null
}

variable "bastion_instance_key" {
  type        = string
  description = "The desired previously created key pair name for the bastion instance"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "The desired public subnet to create bastion instanace"
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

locals  {
  tags = merge(
    var.tags,
    {
      Environment  = var.environment
      VPC          = var.vpc_id
      Provisioning = "terraform"
    },
  )
}