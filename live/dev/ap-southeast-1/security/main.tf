# Lấy thông tin từ state của layer Network
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "flex-apse1-terraform-state"
    key    = "dev/ap-southeast-1/network/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

module "sg" {
  source = "../../../../modules/security"

  name   = "flex"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  alb_ingress_cidrs = ["0.0.0.0/0"]
  
  # Module security đã tự động link:
  # ALB SG -> App SG (port 80, 8080)
  # App SG -> DB SG (port 5432)
  # Nên không cần truyền ID vào nữa
}
