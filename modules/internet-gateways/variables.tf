########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for the Internet Gateway resource"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Internet Gateway will be attached"
  type        = string
}
