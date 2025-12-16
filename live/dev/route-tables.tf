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
# Private Route Tables
########################################
#
# This module creates route tables for private subnets with routes to NAT Gateway.
# Private subnets use NAT Gateway for outbound internet access.
########################################

########################################
# Private Route Table for Subnet 1a
########################################

module "private_route_table_1a" {
  count = var.enable_nat_gateway ? 1 : 0

  source = "../../modules/route-tables/private"

  name           = "dev-flex"
  vpc_id         = module.vpc.vpc_id
  nat_gateway_id = module.nat_gateway[0].nat_gateway_id
  subnet_id      = module.private_subnet_1a.subnet_id
}
