########################################
# GitHub Actions CodeCommit IAM Role
########################################

resource "aws_iam_role" "github_actions_codecommit" {
  name               = "${var.name}-gha-codecommit-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Name = "${var.name}-gha-codecommit-role"
  }
}

########################################
# CodeCommit IAM Policy
########################################

resource "aws_iam_role_policy" "codecommit" {
  name   = "${var.name}-gha-codecommit-policy"
  role   = aws_iam_role.github_actions_codecommit.id
  policy = data.aws_iam_policy_document.codecommit.json
}
