data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "flex-apse1-terraform-state"
    key    = "dev/ap-southeast-1/network/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "flex-apse1-terraform-state"
    key    = "dev/ap-southeast-1/security/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

