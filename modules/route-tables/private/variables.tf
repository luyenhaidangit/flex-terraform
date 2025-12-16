########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for the route table resource"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the route table will be created"
  type        = string
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID for the default route (0.0.0.0/0)"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID to associate with this route table"
  type        = string
}
