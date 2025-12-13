########################################
# General
########################################

variable "name" {
  type        = string
  description = "Name prefix for all resources"
}

variable "cluster_version" {
  type        = string
  default     = "1.31"
  description = "Kubernetes version for EKS cluster"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all resources"
}

########################################
# Network
########################################

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EKS cluster and nodes"
}

variable "public_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of public subnet IDs (optional, for public load balancers)"
}

########################################
# EKS Cluster
########################################

variable "cluster_endpoint_private_access" {
  type        = bool
  default     = true
  description = "Enable private API server endpoint"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  default     = false
  description = "Enable public API server endpoint"
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR blocks allowed to access public endpoint"
}

variable "cluster_enabled_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "List of control plane logging to enable"
}

variable "cluster_log_retention_days" {
  type        = number
  default     = 30
  description = "CloudWatch log retention in days"
}

########################################
# Node Groups
########################################

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    capacity_type  = string # ON_DEMAND or SPOT
    disk_size      = number
    desired_size   = number
    min_size       = number
    max_size       = number
    labels         = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  default = {
    main = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
      desired_size   = 2
      min_size       = 1
      max_size       = 10
      labels         = {}
      taints         = []
    }
  }
  description = "Map of node group configurations"
}

########################################
# Add-ons
########################################

variable "cluster_addons" {
  type = map(object({
    version                  = optional(string)
    resolve_conflicts        = optional(string, "OVERWRITE")
    service_account_role_arn = optional(string)
    configuration_values     = optional(string)
  }))
  default = {}
  description = "Map of EKS add-on configurations"
}

variable "enable_vpc_cni_prefix_delegation" {
  type        = bool
  default     = true
  description = "Enable VPC CNI prefix delegation for higher pod density"
}

########################################
# Karpenter
########################################

variable "enable_karpenter" {
  type        = bool
  default     = false
  description = "Enable Karpenter for node autoscaling"
}

variable "karpenter_namespace" {
  type        = string
  default     = "karpenter"
  description = "Kubernetes namespace for Karpenter"
}

########################################
# ALB Controller
########################################

variable "enable_alb_controller" {
  type        = bool
  default     = false
  description = "Enable AWS Load Balancer Controller"
}

########################################
# External DNS
########################################

variable "enable_external_dns" {
  type        = bool
  default     = false
  description = "Enable External DNS"
}

variable "external_dns_hosted_zone_ids" {
  type        = list(string)
  default     = []
  description = "List of Route53 hosted zone IDs for External DNS"
}

########################################
# Encryption
########################################

variable "cluster_encryption_config" {
  type        = bool
  default     = true
  description = "Enable envelope encryption for Kubernetes secrets"
}

variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "Existing KMS key ARN for secrets encryption (if empty, creates new key)"
}

