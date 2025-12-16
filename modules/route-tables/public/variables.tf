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

variable "internet_gateway_id" {
  description = "Internet Gateway ID for the default route (0.0.0.0/0)"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID to associate with this route table"
  type        = string
}
