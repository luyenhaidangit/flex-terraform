########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for all IAM resources"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider for IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS OIDC provider (without https://)"
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