########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for the security group (e.g., project name)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security group will be created"
  type        = string
}

########################################
# Optional Variables
########################################
