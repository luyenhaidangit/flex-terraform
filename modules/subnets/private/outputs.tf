########################################
# Subnet Outputs
########################################

output "subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "subnet_arn" {
  description = "ARN of the private subnet"
  value       = aws_subnet.private.arn
}

output "subnet_cidr_block" {
  description = "CIDR block of the private subnet"
  value       = aws_subnet.private.cidr_block
}