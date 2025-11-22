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

# S3 bucket chứa Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = "luyenhaidangit-bucket-terraform-state-2211"

  # Bật versioning để có thể rollback state
  versioning {
    enabled = true
  }

  # Block mọi truy cập public
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true

  # Bật server-side encryption AES256
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Prevent destroy (bảo vệ state)
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "tf_state"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}

# DynamoDB table để lock Terraform state
resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "tf_locks"
    Environment = "global"
    Owner       = "luyenhaidangit"
    Project     = "flex"
  }
}
