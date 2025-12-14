########################################
# EKS Cluster - Dev Environment
########################################
#
# This module creates the EKS cluster with:
# - Private endpoint only (no public access)
# - Control plane logging enabled
# - Uses IAM role from eks_iam module
# - Uses security groups from cluster_security_groups module
#
########################################

module "eks" {
  source = "../../modules/eks"
  count  = var.enable_eks ? 1 : 0

  name               = "dev-flex"
  cluster_version    = "1.34"
  private_subnet_ids = [
    module.private_subnet_1a.subnet_id,
    module.private_subnet_1b.subnet_id
  ]

  # From IAM module
  cluster_role_arn = module.eks_iam.cluster_role_arn

  # From Security Groups module
  cluster_security_group_ids = [module.cluster_security_groups.cluster_security_group_id]

  # Encryption
  enable_cluster_encryption = false

  # Logging
  cluster_enabled_log_types = ["api", "audit", "authenticator"]
}
