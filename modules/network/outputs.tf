output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "db_subnet_id" {
  value = aws_subnet.db.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "ssm_vpce_sg_id" {
  description = "Security Group ID for SSM VPC Endpoints"
  value       = var.enable_ssm_endpoints ? aws_security_group.ssm_vpce[0].id : null
}

/*
output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
*/