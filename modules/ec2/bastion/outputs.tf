########################################
# Bastion Instance Outputs
########################################

output "bastion_instance_id" {
  description = "EC2 instance ID of the Bastion"
  value       = aws_instance.bastion.id
}

output "bastion_private_ip" {
  description = "Private IP address of the Bastion"
  value       = aws_instance.bastion.private_ip
}
