########################################
# Cluster Outputs
########################################

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "EKS cluster version"
  value       = module.eks.cluster_version
}

########################################
# OIDC Outputs
########################################

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  value       = module.eks.oidc_provider_arn
}

########################################
# Security Group Outputs
########################################

output "cluster_security_group_id" {
  description = "Cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Node security group ID"
  value       = module.eks.node_security_group_id
}

########################################
# IAM Role Outputs
########################################

output "alb_controller_role_arn" {
  description = "ALB Controller IAM role ARN"
  value       = module.eks.alb_controller_role_arn
}

output "external_dns_role_arn" {
  description = "External DNS IAM role ARN"
  value       = module.eks.external_dns_role_arn
}

output "karpenter_role_arn" {
  description = "Karpenter IAM role ARN"
  value       = module.eks.karpenter_role_arn
}

########################################
# Kubectl Config
########################################

output "kubectl_config" {
  description = "Command to configure kubectl"
  value       = module.eks.kubectl_config
}

