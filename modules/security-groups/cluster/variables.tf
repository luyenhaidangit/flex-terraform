########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for the security groups (e.g., project name or cluster name)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

########################################
# Optional Variables
########################################

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
