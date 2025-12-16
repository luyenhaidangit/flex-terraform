########################################
# NAT Gateway Outputs
########################################

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.this.id
}

output "public_ip" {
  description = "Public IP address of the NAT Gateway (from associated EIP)"
  value       = aws_nat_gateway.this.public_ip
}
