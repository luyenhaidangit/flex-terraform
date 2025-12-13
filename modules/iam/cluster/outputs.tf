########################################
# Cluster IAM Role Outputs
########################################

output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.arn
}

output "cluster_role_name" {
  description = "Name of the EKS cluster IAM role"
  value       = aws_iam_role.cluster.name
}

########################################
# Node IAM Role Outputs
########################################

output "node_role_arn" {
  description = "ARN of the EKS node IAM role"
  value       = aws_iam_role.node.arn
}

output "node_role_name" {
  description = "Name of the EKS node IAM role"
  value       = aws_iam_role.node.name
}

########################################
# EBS CSI Driver IAM Role Outputs
########################################

output "ebs_csi_role_arn" {
  description = "ARN of the EBS CSI driver IAM role"
  value       = var.enable_ebs_csi_irsa ? aws_iam_role.ebs_csi[0].arn : null
}

########################################
# VPC CNI IAM Role Outputs
########################################

output "vpc_cni_role_arn" {
  description = "ARN of the VPC CNI IAM role"
  value       = var.enable_vpc_cni_irsa ? aws_iam_role.vpc_cni[0].arn : null
}
