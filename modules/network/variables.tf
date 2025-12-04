variable "name" {
  type        = string
  description = "Prefix for naming"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "az" {
  type        = string
  description = "Availability Zone to deploy subnets in"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for public subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for private subnet"
}

variable "db_subnet_cidr" {
  type        = string
  description = "CIDR block for database subnet"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}
