########################################
# NAT Gateway
########################################
#
# This module creates a NAT Gateway for private subnets to access the internet.
# The NAT Gateway is placed in a public subnet and uses an Elastic IP address.
########################################

module "nat_gateway" {
  source = "../../modules/nat-gateways"

  name              = "dev-flex"
  eip_allocation_id = module.eip.allocation_id
  subnet_id         = module.public_subnet_1a.subnet_id
}
