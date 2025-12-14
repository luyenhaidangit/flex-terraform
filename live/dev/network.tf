########################################
# VPC
########################################

module "vpc" {
  source = "../../modules/vpc"

  name       = "dev-flex"
  cidr_block = "10.0.0.0/16"
}

########################################
# Private Subnets
########################################

module "private_subnet_1a" {
  source = "../../modules/subnets/private"

  name              = "dev-flex"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-southeast-1a"
}

module "private_subnet_1b" {
  source = "../../modules/subnets/private"

  name              = "dev-flex"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-southeast-1b"
}