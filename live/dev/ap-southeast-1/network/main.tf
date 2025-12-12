module "network" {
  source = "../../../../modules/network"

  name     = "dev-flex"
  vpc_cidr = "10.10.0.0/16"
  azs      = ["ap-southeast-1a", "ap-southeast-1b"]

  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
  db_subnet_cidrs      = ["10.10.21.0/24", "10.10.22.0/24"]

  # NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true # Cost saving for dev

  # EKS subnet tags
  enable_eks_tags  = true
  eks_cluster_name = "dev-flex"

  tags = {
    Environment = "dev"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}
