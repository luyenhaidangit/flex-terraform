# 1. Centralized Logging Bucket
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "flex-apse1-central-logging"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "central-logging"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

# 2. Block public access
resource "aws_s3_bucket_public_access_block" "logging_public" {
  bucket                  = aws_s3_bucket.logging_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# 3. Enable versioning
resource "aws_s3_bucket_versioning" "logging_versioning" {
  bucket = aws_s3_bucket.logging_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Encrypt bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "logging_sse" {
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 5. Chính sách cho phép ALB, VPC Flow Logs ghi log
resource "aws_s3_bucket_policy" "logging_bucket_policy" {
  bucket = aws_s3_bucket.logging_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Cho phép GetBucketAcl (bucket-level)
      {
        Sid      = "AWSLogDeliveryAclCheck",
        Effect   = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.logging_bucket.arn
      },

      # Cho phép PutObject (object-level)
      {
        Sid      = "AWSLogDeliveryWrite",
        Effect   = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.logging_bucket.arn}/*"
      }
    ]
  })
}
