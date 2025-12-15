########################################
# EKS IAM Roles
########################################
#
# This module creates required IAM roles for the EKS cluster:
# - Cluster Role: Used by the EKS control plane.
# - Node Role: Used by EKS worker nodes.
# - IRSA Roles (optional, requires OIDC): Used by EKS add-ons via IAM Roles for Service Accounts.
########################################

module "eks_iam" {
  source = "../../modules/iam/cluster"

  name = "dev-flex"

  # oidc_provider_arn   = data.terraform_remote_state.eks.outputs.oidc_provider_arn
  # oidc_provider_url   = data.terraform_remote_state.eks.outputs.oidc_provider_url
  # enable_ebs_csi_irsa = true
  # enable_vpc_cni_irsa = true
}

########################################
# Bastion IAM Role
########################################
#
# This module creates IAM role for the bastion host:
# - Bastion Role: Allows EC2 instance to use SSM Session Manager
# - Instance Profile: Attached to the bastion EC2 instance
########################################

module "bastion_iam" {
  source = "../../modules/iam/bastion"

  name = "dev-flex"
}

########################################
# GitHub Actions CodeCommit IAM Role
########################################
#
# This module creates IAM role for GitHub Actions to access CodeCommit:
# - Role: Allows GitHub Actions workflows to assume role via OIDC
# - Policy: Grants CodeCommit access (read-only or read-write)
#
# Usage example:
#   - github_repositories: ["owner/repo:*"] or ["owner/repo:ref:refs/heads/main"]
#   - codecommit_repositories: ["arn:aws:codecommit:region:account:repo-name"]
########################################

# module "github_actions_codecommit" {
#   source = "../../modules/iam/gha_codecommit"
#
#   name               = "dev-flex"
#   oidc_provider_arn = module.github_oidc.oidc_provider_arn
#   oidc_provider_url = module.github_oidc.oidc_provider_url_without_protocol
#
#   github_repositories = [
#     "owner/repo:*"  # Allow all branches/tags, or use "owner/repo:ref:refs/heads/main" for specific branch
#   ]
#
#   codecommit_repositories = [
#     "arn:aws:codecommit:ap-southeast-1:ACCOUNT_ID:repo-name"
#   ]
#
#   permissions = "read-write"  # or "read-only"
# }