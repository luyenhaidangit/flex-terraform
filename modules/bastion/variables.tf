variable "name" {
  description = "Prefix for Bastion resources"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID where the Bastion EC2 runs"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro for Free Tier)"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Custom AMI ID (optional). If null → auto lookup Amazon Linux 2023 x86_64"
  type        = string
  default     = null
}

variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
}

variable "security_group_ids" {
  description = "List of Security Group IDs to attach to Bastion EC2"
  type        = list(string)
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring (additional cost)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
