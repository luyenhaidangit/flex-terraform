terraform {
  backend "s3" {
    bucket         = "flex-apse1-terraform-state"
    key            = "dev/ap-southeast-1/security/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform_state_locks"
    encrypt        = true
  }
}
