module "bastion" {
  source = "../../../../modules/bastion"

  name      = "flex"
  subnet_id = data.terraform_remote_state.network.outputs.private_subnet_id

  ami_id                     = "ami-093a7f5fbae13ff67"       # Amazon Linux 2023 AMI 2023.9.20251117.1 x86_64 HVM kernel-6.1
  instance_type              = "t2.micro"                    # t2.micro
  enable_detailed_monitoring = false                         # Free tier eligible
  
  volume_size                = 8

  # Security Group từ security module
  security_group_ids = [
    data.terraform_remote_state.security.outputs.bastion_sg_id
  ]
  
  tags = {
    Environment = "dev"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

