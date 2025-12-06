variable "name" {
  description = "Prefix name for all SGs"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# ALB inbound CIDRs (Internet or CloudFront)
variable "alb_ingress_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Extra dynamic rules for App SG
variable "extra_rules" {
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

# VPC CIDR for SSM VPC Endpoints
variable "vpc_cidr" {
  description = "VPC CIDR block for SSM endpoints ingress"
  type        = string
  default     = null
}

# Enable SSM VPC Endpoints SG
variable "enable_ssm_endpoints" {
  description = "Create Security Group for SSM VPC Endpoints"
  type        = bool
  default     = false
}