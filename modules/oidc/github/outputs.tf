########################################
# GitHub OIDC Provider Outputs
########################################

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "oidc_provider_url" {
  description = "URL of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.url
}

output "oidc_provider_url_without_protocol" {
  description = "URL of the GitHub OIDC provider without https:// prefix (for use in IAM condition keys)"
  value       = replace(aws_iam_openid_connect_provider.github.url, "https://", "")
}
