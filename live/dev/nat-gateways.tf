########################################
# NAT Gateway
########################################
#
# This module creates a NAT Gateway for private subnets to access the internet.
# The NAT Gateway is placed in a public subnet and uses an Elastic IP address.
# Set enable_nat_gateway = false to disable and save costs.
########################################

module "nat_gateway" {
  count = var.enable_nat_gateway ? 1 : 0

  source = "../../modules/nat-gateways"

  name              = "dev-flex"
  eip_allocation_id = module.eip[0].allocation_id
  subnet_id         = module.public_subnet_1a.subnet_id
}
