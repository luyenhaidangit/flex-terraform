########################################
# SSM VPC Endpoints
########################################

module "ssm_vpc_endpoints" {
  source = "../../modules/vpc-endpoints/ssm"

  name             = "dev-flex"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = [
    module.private_subnet_1a.subnet_id,
    module.private_subnet_1b.subnet_id
  ]
  security_group_id = module.ssm_vpce_security_group.ssm_vpce_security_group_id
}
