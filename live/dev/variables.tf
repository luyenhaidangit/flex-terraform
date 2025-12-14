variable "enable_eks" {
  description = "Enable EKS cluster. Set false to destroy and save costs."
  type        = bool
  default     = true
}