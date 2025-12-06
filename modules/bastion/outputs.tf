output "bastion_instance_id" {
  description = "EC2 instance ID of the Bastion"
  value       = aws_instance.this.id
}

output "bastion_private_ip" {
  description = "Private IP address of the Bastion"
  value       = aws_instance.this.private_ip
}

output "bastion_sg_id" {
  description = "Security Group ID of the Bastion"
  value       = aws_security_group.this.id
}
