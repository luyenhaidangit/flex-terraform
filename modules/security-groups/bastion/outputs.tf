########################################
# Bastion Security Group Outputs
########################################

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion_sg.id
}
