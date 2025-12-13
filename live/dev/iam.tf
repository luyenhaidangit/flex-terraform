########################################
# EKS IAM Roles
########################################

module "eks_iam" {
  source = "../../modules/iam/cluster"

  name = "dev-flex"
}
