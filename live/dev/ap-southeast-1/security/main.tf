module "sg" {
  source = "../../../../modules/security"

  name     = "flex"
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id
  vpc_cidr = data.terraform_remote_state.network.outputs.vpc_cidr

  alb_ingress_cidrs    = ["0.0.0.0/0"]
  enable_ssm_endpoints = true
}
