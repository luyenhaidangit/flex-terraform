variable "enable_eks" {
  description = "Enable EKS cluster. Set false to destroy and save costs."
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway. Set false to destroy and save costs."
  type        = bool
  default     = true
}