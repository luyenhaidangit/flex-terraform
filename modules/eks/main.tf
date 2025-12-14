########################################
# EKS Cluster
########################################

resource "aws_eks_cluster" "this" {
  
  name     = "${var.name}-cluster"
  version  = var.cluster_version
  role_arn = var.cluster_role_arn

  ########################################
  # Networking
  ########################################
  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = var.cluster_security_group_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  ########################################
  # Encryption at Rest (KMS)
  ########################################
  dynamic "encryption_config" {
    for_each = (
      var.enable_cluster_encryption && var.kms_key_arn != null
    ) ? [1] : []

    content {
      provider {
        key_arn = var.kms_key_arn
      }
      resources = ["secrets"]
    }
  }

  ########################################
  # Control Plane Logging
  ########################################

  enabled_cluster_log_types = var.cluster_enabled_log_types

  ########################################
  # Access & Authentication
  ########################################
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  ########################################
  # Tags
  ########################################
  tags = {
    Name = "${var.name}-cluster"
  }
}