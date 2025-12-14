########################################
# Security Groups Outputs
########################################

output "cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = module.cluster_security_groups.cluster_security_group_id
}

output "node_security_group_id" {
  description = "ID of the EKS node security group"
  value       = module.cluster_security_groups.node_security_group_id
}

########################################
# IAM Outputs
########################################

output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = module.eks_iam.cluster_role_arn
}

output "cluster_role_name" {
  description = "Name of the EKS cluster IAM role"
  value       = module.eks_iam.cluster_role_name
}

output "node_role_arn" {
  description = "ARN of the EKS node IAM role"
  value       = module.eks_iam.node_role_arn
}

output "node_role_name" {
  description = "Name of the EKS node IAM role"
  value       = module.eks_iam.node_role_name
}

########################################
# EKS Cluster Outputs
########################################

output "eks_enabled" {
  description = "Whether EKS cluster is enabled"
  value       = var.enable_eks
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = var.enable_eks ? module.eks[0].cluster_name : null
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster API server"
  value       = var.enable_eks ? module.eks[0].cluster_endpoint : null
}

output "eks_cluster_version" {
  description = "Kubernetes version of the cluster"
  value       = var.enable_eks ? module.eks[0].cluster_version : null
}

output "eks_oidc_issuer_url" {
  description = "OIDC issuer URL for IRSA"
  value       = var.enable_eks ? module.eks[0].oidc_issuer_url : null
}
