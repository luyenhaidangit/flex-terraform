module "network" {
  source = "../../../../modules/network"

  name     = "dev-main"
  vpc_cidr = "10.10.0.0/16"
  az       = "ap-southeast-1a"

  public_subnet_cidr  = "10.10.1.0/24"
  private_subnet_cidr = "10.10.11.0/24"
  db_subnet_cidr      = "10.10.21.0/24"

  enable_ssm_endpoints = false

  tags = {
    Name        = "network"
    Environment = "dev"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}
