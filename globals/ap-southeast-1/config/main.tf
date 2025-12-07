# 1. Bucket dùng để lưu AWS Config
resource "aws_s3_bucket" "config_bucket" {
  bucket = "flex-apse1-config-logs"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "aws-config-logs"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

# 2. Config public policy
resource "aws_s3_bucket_public_access_block" "config_public" {
  bucket                  = aws_s3_bucket.config_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# 3. Versioning để tránh mất log
resource "aws_s3_bucket_versioning" "config_versioning" {
  bucket = aws_s3_bucket.config_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Encryption AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "config_sse" {
  bucket = aws_s3_bucket.config_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 5. Thêm Config role
resource "aws_iam_role" "config_role" {
  name = "flex-apse1-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "config.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# 6.Thêm iam role cho recorder
resource "aws_iam_role_policy_attachment" "config_role_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# 7. Cấp quyền ghi vào s3 cho Config
resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSConfigBucketPermissionsCheck",
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.config_bucket.arn
      },
      {
        Sid    = "AWSConfigBucketDelivery",
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.config_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# 8. Cấu hình AWS Config Recorder
resource "aws_config_configuration_recorder" "recorder" {
  name = "flex-apse1-config"

  role_arn = aws_iam_role.config_role.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.config_role_policy
  ]
}

# 9. Delivery channel cho Config
resource "aws_config_delivery_channel" "delivery" {
  name           = "flex-apse1-delivery"
  s3_bucket_name = aws_s3_bucket.config_bucket.id

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }

  depends_on = [
    aws_s3_bucket_policy.config_bucket_policy
  ]
}

# 10. Enable recorder
resource "aws_config_configuration_recorder_status" "recorder_status" {
  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = false # ← Tắt recorder để tiết kiệm chi phí

  depends_on = [
    aws_config_delivery_channel.delivery
  ]
}
