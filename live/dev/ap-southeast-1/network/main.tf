module "network" {
  source = "../../../../modules/network"

  name                 = "dev-main"
  vpc_cidr             = "10.10.0.0/16"
  azs                  = ["ap-southeast-1a", "ap-southeast-1b"]

  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
  db_subnet_cidrs      = ["10.10.21.0/24", "10.10.22.0/24"]

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "aws-foundation"
  }
}
