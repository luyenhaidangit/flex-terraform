variable "name" {
  type        = string
  description = "Prefix for naming"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones"
}

variable "public_subnet_cidrs" {
  type        = list(string)
}

variable "private_subnet_cidrs" {
  type        = list(string)
}

variable "db_subnet_cidrs" {
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
}
