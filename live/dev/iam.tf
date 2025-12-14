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
