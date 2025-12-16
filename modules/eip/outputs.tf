########################################
# EIP Outputs
########################################

output "allocation_id" {
  description = "EIP allocation ID"
  value       = aws_eip.this.id
}

output "public_ip" {
  description = "EIP public IP address"
  value       = aws_eip.this.public_ip
}
