########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for subnet resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid CIDR notation (e.g., 10.0.11.0/24)."
  }
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

########################################
# Optional Variables
########################################
