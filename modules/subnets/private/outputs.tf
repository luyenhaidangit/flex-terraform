########################################
# Subnet Outputs
########################################

output "subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.this.id
}

output "subnet_arn" {
  description = "ARN of the private subnet"
  value       = aws_subnet.this.arn
}

output "subnet_cidr_block" {
  description = "CIDR block of the private subnet"
  value       = aws_subnet.this.cidr_block
}