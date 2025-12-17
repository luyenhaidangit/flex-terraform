########################################
# Bastion Host
# Required: SSM Group, Route Table, Endpoint,...
########################################

module "bastion" {
  source = "../../modules/ec2/bastion"

  name                = "dev-flex"
  subnet_id           = module.public_subnet_1a.subnet_id
  security_group_id   = module.bastion_security_group.bastion_security_group_id
  instance_profile_name = module.bastion_iam.bastion_instance_profile_name

  # Optional
  instance_type = "t3.micro"
  volume_size   = 8
}