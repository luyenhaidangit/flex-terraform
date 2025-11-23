terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# 1. Tạo s3 lưu  tf state
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "flex-apse1-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "terraform-state"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

# 2. Versioning cho rollback state
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Block mọi truy cập public
resource "aws_s3_bucket_public_access_block" "terraform_state_public" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# 4. Bật Server Side Encryption AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_sse" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 5. DynamoDB table dùng để lock Terraform state
resource "aws_dynamodb_table" "terraform_state_locks" {
  name         = "terraform_state_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-locks"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}
