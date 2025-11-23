############################################
# Terraform Admin Role
############################################
resource "aws_iam_role" "terraform_admin" {
  name = "flex-terraform-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "TerraformAdminRole"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

resource "aws_iam_role_policy_attachment" "terraform_admin_policy" {
  role       = aws_iam_role.terraform_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

############################################
# ReadOnly Role
############################################
resource "aws_iam_role" "read_only" {
  name = "flex-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "ReadOnlyRole"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

resource "aws_iam_role_policy_attachment" "read_only_policy" {
  role       = aws_iam_role.read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

############################################
# Support Role
############################################
resource "aws_iam_role" "support_role" {
  name = "flex-support-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "SupportRole"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

resource "aws_iam_role_policy_attachment" "support_role_policy" {
  role       = aws_iam_role.support_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}
