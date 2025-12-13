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
