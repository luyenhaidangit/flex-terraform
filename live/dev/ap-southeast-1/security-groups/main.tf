module "sg" {
  source = "../../../../modules/security-groups"

  name   = "flex"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  alb_ingress_cidrs = ["0.0.0.0/0"]
}
