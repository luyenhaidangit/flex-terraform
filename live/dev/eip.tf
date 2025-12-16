########################################
# Elastic IP (EIP) for NAT Gateway
########################################
#
# This module creates an Elastic IP address for use with NAT Gateway.
# The EIP will be allocated in VPC domain and can be associated with a NAT Gateway.
########################################

module "eip" {
  source = "../../modules/eip"

  name = "dev-flex"
}
