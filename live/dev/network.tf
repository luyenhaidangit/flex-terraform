########################################
# VPC - Dev Environment
########################################

module "vpc" {
  source = "../../modules/vpc"

  name       = "dev-flex"
  cidr_block = "10.0.0.0/16"
}