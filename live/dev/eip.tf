########################################
# Elastic IP (EIP) for NAT Gateway
########################################
#
# This module creates an Elastic IP address for use with NAT Gateway.
# The EIP will be allocated in VPC domain and can be associated with a NAT Gateway.
# Set enable_nat_gateway = false to disable and save costs.
########################################

module "eip" {
  count = var.enable_nat_gateway ? 1 : 0

  source = "../../modules/eip"

  name = "dev-flex"
}
