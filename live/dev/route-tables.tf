########################################
# Public Route Tables
########################################
#
# This module creates route tables for public subnets with routes to Internet Gateway.
# Public subnets use Internet Gateway for direct internet access.
########################################

########################################
# Public Route Table for Subnet 1a
########################################

module "public_route_table_1a" {
  source = "../../modules/route-tables/public"

  name                = "dev-flex"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  subnet_id           = module.public_subnet_1a.subnet_id
}

########################################
# Public Route Table for Subnet 1b
########################################

module "public_route_table_1b" {
  source = "../../modules/route-tables/public"

  name                = "dev-flex"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  subnet_id           = module.public_subnet_1b.subnet_id
}
