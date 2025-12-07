output "bastion_instance_id" {
  description = "EC2 instance ID of the Bastion"
  value       = module.bastion.bastion_instance_id
}

output "bastion_private_ip" {
  description = "Private IP address of the Bastion"
  value       = module.bastion.bastion_private_ip
}

