variable "name" {
  type        = string
  description = "Prefix for naming"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "az" {
  type = string
  description = "List of Availability Zones"
}

variable "public_subnet_cidr" {
  type        = string
}

variable "private_subnet_cidr" {
  type        = string
}

variable "db_subnet_cidr" {
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
}
