########################################
# EKS Cluster Security Groups
########################################

module "cluster_security_groups" {
  source = "../../modules/security-groups/cluster"

  name   = "dev-flex"
  vpc_id = module.vpc.vpc_id
}

########################################
# Bastion Security Group
########################################

module "bastion_security_group" {
  source = "../../modules/security-groups/bastion"

  name   = "dev-flex"
  vpc_id = module.vpc.vpc_id
}

########################################
# SSM VPC Endpoints Security Group
########################################

module "ssm_vpce_security_group" {
  source = "../../modules/security-groups/ssm"

  name     = "dev-flex"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr_block
}