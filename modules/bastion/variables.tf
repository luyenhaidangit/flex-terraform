variable "name" {
  description = "Prefix for Bastion resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Bastion will be provisioned"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID where the Bastion EC2 runs"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Custom AMI ID (optional). If null → auto AMI lookup"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
