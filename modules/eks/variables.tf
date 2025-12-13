########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for all EKS resources"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.34"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

########################################
# Cluster Endpoint Access
########################################

variable "cluster_endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

########################################
# Encryption
########################################

variable "cluster_encryption_config" {
  description = "Enable secrets encryption with KMS"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of existing KMS key for secrets encryption. If empty, a new key will be created"
  type        = string
  default     = ""
}

########################################
# Logging
########################################

variable "cluster_enabled_log_types" {
  description = "List of control plane log types to enable (api, audit, authenticator, controllerManager, scheduler)"
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

########################################
# Tags
########################################

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
