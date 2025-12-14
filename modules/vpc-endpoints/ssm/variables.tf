########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for resources (e.g., project name)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where endpoints will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where endpoints will be created (typically private subnets)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the VPC endpoints"
  type        = string
}

########################################
# Optional Variables
########################################

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
