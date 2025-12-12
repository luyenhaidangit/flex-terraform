terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "flex-terraform-state"
    key            = "dev/ap-southeast-1/eks/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "flex-terraform-locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "flex"
      ManagedBy   = "terraform"
    }
  }
}
