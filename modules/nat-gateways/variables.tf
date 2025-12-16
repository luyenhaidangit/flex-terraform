########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for the NAT Gateway resource"
  type        = string
}

variable "eip_allocation_id" {
  description = "Elastic IP allocation ID to associate with the NAT Gateway"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID where the NAT Gateway will be created"
  type        = string
}
