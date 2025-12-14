########################################
# Bastion IAM Role Outputs
########################################

output "bastion_role_arn" {
  description = "ARN of the bastion IAM role"
  value       = aws_iam_role.bastion.arn
}

output "bastion_role_name" {
  description = "Name of the bastion IAM role"
  value       = aws_iam_role.bastion.name
}

########################################
# Instance Profile Outputs
########################################

output "bastion_instance_profile_name" {
  description = "Name of the bastion instance profile"
  value       = aws_iam_instance_profile.bastion.name
}
