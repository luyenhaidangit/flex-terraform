########################################
# EKS Cluster - Dev Environment
########################################

module "eks" {
  source = "../../../../modules/eks"

  name            = "dev-flex"
  cluster_version = "1.31"

  # Network
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  public_subnet_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids

  # Cluster access (private only)
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  # Logging
  cluster_enabled_log_types  = ["api", "audit", "authenticator"]
  cluster_log_retention_days = 7 # Short retention for dev

  # Node Groups
  node_groups = {
    main = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
      desired_size   = 2
      min_size       = 1
      max_size       = 5
      labels = {
        "workload" = "general"
      }
      taints = []
    }
  }

  # Add-ons
  enable_vpc_cni_prefix_delegation = true

  # Controllers
  enable_alb_controller = true
  enable_external_dns   = true
  enable_karpenter      = true

  # Encryption
  cluster_encryption_config = true

  tags = {
    Environment = "dev"
    Owner       = "luyenhaidangit"
    Project     = "flex"
    ManagedBy   = "terraform"
  }
}

