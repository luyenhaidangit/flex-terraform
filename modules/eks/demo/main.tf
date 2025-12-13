########################################
# EKS Cluster
########################################

resource "aws_eks_cluster" "this" {
  name     = "${var.name}-cluster"
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    security_group_ids      = [aws_security_group.cluster.id]
  }

  # Secrets encryption with KMS
  dynamic "encryption_config" {
    for_each = var.cluster_encryption_config ? [1] : []
    content {
      provider {
        key_arn = var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.eks[0].arn
      }
      resources = ["secrets"]
    }
  }

  # Control plane logging
  enabled_cluster_log_types = var.cluster_enabled_log_types

  # Access config for EKS API authentication
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-cluster" }
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_vpc_resource_controller,
    aws_cloudwatch_log_group.cluster,
  ]
}

########################################
# CloudWatch Log Group
########################################

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.name}-cluster/cluster"
  retention_in_days = var.cluster_log_retention_days

  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-logs" }
  )
}

########################################
# OIDC Provider for IRSA
########################################

data "tls_certificate" "eks" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]

  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-oidc" }
  )
}

