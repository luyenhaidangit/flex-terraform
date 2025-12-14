########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for all EKS resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "cluster_security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
}

########################################
# Optional Variables
########################################

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "enable_cluster_encryption" {
  description = "Enable secrets encryption with KMS"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN of KMS key for secrets encryption. Required when enable_cluster_encryption = true"
  type        = string
  default     = null

  validation {
    condition     = !var.enable_cluster_encryption || var.kms_key_arn != null
    error_message = "kms_key_arn is required when enable_cluster_encryption = true."
  }
}

variable "cluster_enabled_log_types" {
  description = "List of control plane log types to enable (api, audit, authenticator, controllerManager, scheduler)"
  type        = list(string)
  default     = ["api","audit","authenticator","controllerManager","scheduler"]
}

