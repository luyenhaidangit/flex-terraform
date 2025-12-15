########################################
# GitHub Actions Assume Role Policy
########################################

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${var.oidc_provider_url}:sub"
      values   = var.github_repositories
    }
  }
}

########################################
# CodeCommit Policy Document
########################################

data "aws_iam_policy_document" "codecommit" {
  dynamic "statement" {
    for_each = var.codecommit_repositories
    content {
      effect = "Allow"
      actions = var.permissions == "read-write" ? [
        "codecommit:GitPush",
        "codecommit:GitPull",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetRepository",
        "codecommit:ListBranches",
        "codecommit:ListRepositories",
        "codecommit:BatchGetRepositories",
        "codecommit:CreateBranch",
        "codecommit:DeleteBranch",
        "codecommit:PutFile",
        "codecommit:GetFile",
        "codecommit:GetDifferences",
        "codecommit:PostCommentForPullRequest",
        "codecommit:PostCommentForComparedCommit",
        "codecommit:GetCommentsForPullRequest",
        "codecommit:GetCommentsForComparedCommit",
        "codecommit:GetPullRequest",
        "codecommit:ListPullRequests",
        "codecommit:CreatePullRequest",
        "codecommit:MergePullRequest",
        "codecommit:UpdatePullRequest",
        "codecommit:PostCommentReply",
        "codecommit:GetMergeCommit",
        "codecommit:GetMergeConflicts",
        "codecommit:GetMergeOptions",
        "codecommit:TestRepositoryTriggers",
        "codecommit:PutRepositoryTriggers",
        "codecommit:GetRepositoryTriggers",
        "codecommit:ListRepositoriesForApprovalRuleTemplate",
        "codecommit:GetApprovalRuleTemplate",
        "codecommit:ListApprovalRuleTemplates"
      ] : [
        "codecommit:GitPull",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetRepository",
        "codecommit:ListBranches",
        "codecommit:ListRepositories",
        "codecommit:BatchGetRepositories",
        "codecommit:GetFile",
        "codecommit:GetDifferences",
        "codecommit:GetPullRequest",
        "codecommit:ListPullRequests",
        "codecommit:GetCommentsForPullRequest",
        "codecommit:GetCommentsForComparedCommit",
        "codecommit:GetMergeCommit",
        "codecommit:GetMergeConflicts",
        "codecommit:GetMergeOptions"
      ]
      resources = [statement.value]
    }
  }
}
