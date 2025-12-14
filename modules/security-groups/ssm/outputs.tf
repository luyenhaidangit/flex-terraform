########################################
# SSM VPC Endpoints Security Group Outputs
########################################

output "ssm_vpce_security_group_id" {
  description = "ID of the SSM VPC endpoints security group"
  value       = aws_security_group.ssm_vpce.id
}
