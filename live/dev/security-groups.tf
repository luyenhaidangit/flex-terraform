########################################
# EKS Cluster Security Groups - Dev Environment
########################################

module "cluster_security_groups" {
  source = "../../modules/security-groups/cluster"

  name   = "dev-flex"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
}
