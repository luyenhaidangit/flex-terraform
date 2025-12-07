module "bastion" {
  source = "../../../../modules/bastion"

  name      = "flex"
  vpc_id    = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id = data.terraform_remote_state.network.outputs.private_subnet_id

  # Security Group từ security module
  security_group_ids = [
    data.terraform_remote_state.security.outputs.bastion_sg_id
  ]

  instance_type = "t3.micro"
  volume_size   = 8

  tags = {
    Environment = "dev"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

