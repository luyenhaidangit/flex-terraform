########################################
# Required Variables
########################################

variable "name" {
  description = "Name prefix for all IAM resources"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the GitHub OIDC provider without https:// prefix (e.g., token.actions.githubusercontent.com)"
  type        = string
}

variable "github_repositories" {
  description = "List of GitHub repositories allowed to assume this role (e.g., ['owner/repo:*'] or ['owner/repo:ref:refs/heads/main'])"
  type        = list(string)
}

variable "codecommit_repositories" {
  description = "List of CodeCommit repository ARNs that this role can access"
  type        = list(string)
}

########################################
# Optional Variables
########################################

variable "permissions" {
  description = "CodeCommit permissions: 'read-only' or 'read-write'"
  type        = string
  default     = "read-write"
  validation {
    condition     = contains(["read-only", "read-write"], var.permissions)
    error_message = "Permissions must be either 'read-only' or 'read-write'."
  }
}
