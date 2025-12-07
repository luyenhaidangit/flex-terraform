output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "db_subnet_id" {
  value = module.network.db_subnet_id
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "ssm_vpce_sg_id" {
  description = "Security Group ID for SSM VPC Endpoints"
  value       = module.network.ssm_vpce_sg_id
}
