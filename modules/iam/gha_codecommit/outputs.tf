########################################
# GitHub Actions CodeCommit Role Outputs
########################################

output "role_arn" {
  description = "ARN of the GitHub Actions CodeCommit IAM role"
  value       = aws_iam_role.github_actions_codecommit.arn
}

output "role_name" {
  description = "Name of the GitHub Actions CodeCommit IAM role"
  value       = aws_iam_role.github_actions_codecommit.name
}
