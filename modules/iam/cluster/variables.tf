########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for all IAM resources"
  type        = string
}

########################################
# Optional Variables - IRSA
########################################

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider for IRSA. If not provided, IRSA roles will not be created."
  type        = string
  default     = null
}

variable "oidc_provider_url" {
  description = "URL of the EKS OIDC provider (without https://). If not provided, IRSA roles will not be created."
  type        = string
  default     = null
}

variable "enable_ebs_csi_irsa" {
  description = "Enable EBS CSI Driver IRSA role"
  type        = bool
  default     = false
}

variable "enable_vpc_cni_irsa" {
  description = "Enable VPC CNI IRSA role"
  type        = bool
  default     = false
}
