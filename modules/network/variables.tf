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
  description = "List of Availability Zones to deploy subnets in"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets (one per AZ)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets (one per AZ)"
}

variable "db_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for database subnets (one per AZ)"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable NAT Gateway for private subnets"
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Use single NAT Gateway instead of one per AZ (cost saving)"
}

variable "enable_eks_tags" {
  type        = bool
  default     = false
  description = "Add EKS-specific tags to subnets for auto-discovery"
}

variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "EKS cluster name for subnet tagging (required if enable_eks_tags = true)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}
