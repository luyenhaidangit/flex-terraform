########################################
# Cluster Outputs
########################################

output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = aws_eks_cluster.this.version
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for cluster authentication"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

########################################
# OIDC Outputs
########################################

output "oidc_provider_arn" {
  description = "OIDC Provider ARN for IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "OIDC Provider URL (without https://)"
  value       = replace(aws_iam_openid_connect_provider.eks.url, "https://", "")
}

########################################
# Security Group Outputs
########################################

output "cluster_security_group_id" {
  description = "Security group ID for EKS cluster control plane"
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Security group ID for EKS worker nodes"
  value       = aws_security_group.node.id
}

########################################
# IAM Role Outputs
########################################

output "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  value       = aws_iam_role.cluster.arn
}

output "node_role_arn" {
  description = "IAM role ARN for EKS nodes"
  value       = aws_iam_role.node.arn
}

output "ebs_csi_role_arn" {
  description = "IAM role ARN for EBS CSI driver"
  value       = aws_iam_role.ebs_csi.arn
}

output "vpc_cni_role_arn" {
  description = "IAM role ARN for VPC CNI"
  value       = aws_iam_role.vpc_cni.arn
}

########################################
# ALB Controller Outputs
########################################

output "alb_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = var.enable_alb_controller ? aws_iam_role.alb_controller[0].arn : null
}

########################################
# External DNS Outputs
########################################

output "external_dns_role_arn" {
  description = "IAM role ARN for External DNS"
  value       = var.enable_external_dns ? aws_iam_role.external_dns[0].arn : null
}

########################################
# Karpenter Outputs
########################################

output "karpenter_role_arn" {
  description = "IAM role ARN for Karpenter controller"
  value       = var.enable_karpenter ? aws_iam_role.karpenter[0].arn : null
}

output "karpenter_node_role_arn" {
  description = "IAM role ARN for Karpenter-provisioned nodes"
  value       = var.enable_karpenter ? aws_iam_role.karpenter_node[0].arn : null
}

output "karpenter_queue_url" {
  description = "SQS queue URL for Karpenter interruption handling"
  value       = var.enable_karpenter ? aws_sqs_queue.karpenter[0].url : null
}

output "karpenter_queue_name" {
  description = "SQS queue name for Karpenter interruption handling"
  value       = var.enable_karpenter ? aws_sqs_queue.karpenter[0].name : null
}

########################################
# Node Group Outputs
########################################

output "node_groups" {
  description = "Map of node group names to their attributes"
  value = {
    for k, v in aws_eks_node_group.this : k => {
      arn          = v.arn
      status       = v.status
      capacity_type = v.capacity_type
    }
  }
}

########################################
# KMS Outputs
########################################

output "kms_key_arn" {
  description = "KMS key ARN used for secrets encryption"
  value       = var.cluster_encryption_config ? (var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.eks[0].arn) : null
}

########################################
# Kubectl Configuration
########################################

output "kubectl_config" {
  description = "kubectl configuration command"
  value       = "aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${aws_eks_cluster.this.name}"
}

