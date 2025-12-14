########################################
# SSM VPC Endpoints
########################################

data "aws_region" "current" {}

# SSM endpoints required for Session Manager
locals {
  ssm_endpoints = [
    "ssm",           # Systems Manager
    "ssmmessages",   # Session Manager
    "ec2messages"    # EC2 Messages
  ]
}

resource "aws_vpc_endpoint" "ssm" {
  for_each = var.enable_ssm_endpoints ? toset(local.ssm_endpoints) : toset([])

  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [var.security_group_id]
  private_dns_enabled = true

  tags =  {
    Name = "${var.name}-${each.key}-endpoint"
  }
}