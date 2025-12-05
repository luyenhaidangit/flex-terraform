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

# App inbound allowed SG (only ALB should call App)
variable "app_ingress_sg_ids" {
  type        = list(string)
  default     = []
}

# DB inbound allowed SG (only App should call DB)
variable "db_ingress_sg_ids" {
  type        = list(string)
  default     = []
}

# Extra dynamic rules
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
