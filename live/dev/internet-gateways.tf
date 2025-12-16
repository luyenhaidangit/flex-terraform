########################################
# Internet Gateway
########################################
#
# This module creates an Internet Gateway and attaches it to the VPC.
# The Internet Gateway enables communication between resources in the VPC and the internet.
# Required for public subnets to have internet access.
########################################

module "internet_gateway" {
  source = "../../modules/internet-gateways"

  name   = "dev-flex"
  vpc_id = module.vpc.vpc_id
}
