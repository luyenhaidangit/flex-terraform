########################################
# Subnet Outputs
########################################

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "subnet_arn" {
  description = "ARN of the public subnet"
  value       = aws_subnet.public.arn
}

output "subnet_cidr_block" {
  description = "CIDR block of the public subnet"
  value       = aws_subnet.public.cidr_block
}
