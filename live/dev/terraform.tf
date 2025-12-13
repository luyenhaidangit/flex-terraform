terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "flex-apse1-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform_state_locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
