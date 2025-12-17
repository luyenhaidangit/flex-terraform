########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for bastion resources"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID where the Bastion EC2 runs"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the bastion host"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for the bastion host"
  type        = string
}

########################################
# Optional Variables
########################################

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

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
}
