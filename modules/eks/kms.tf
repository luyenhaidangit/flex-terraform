########################################
# KMS Key for EKS Secrets Encryption
########################################

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "eks" {
  count = var.cluster_encryption_config && var.kms_key_arn == "" ? 1 : 0

  description             = "KMS key for EKS cluster ${var.name} secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow EKS Cluster"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-kms" }
  )
}

resource "aws_kms_alias" "eks" {
  count = var.cluster_encryption_config && var.kms_key_arn == "" ? 1 : 0

  name          = "alias/${var.name}-eks"
  target_key_id = aws_kms_key.eks[0].key_id
}

