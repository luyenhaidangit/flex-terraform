module "network" {
  source = "../../../../modules/network"

  name                 = "dev-main"
  vpc_cidr             = "10.10.0.0/16"
  az                   = "ap-southeast-1a"

  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.11.0/24"
  db_subnet_cidr      = "10.0.21.0/24"

  tags = {
    Name        = "network"
    Environment = "dev"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}
