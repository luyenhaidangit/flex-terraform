output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "Security Group ID for App layer"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "Security Group ID for Database"
  value       = aws_security_group.db.id
}

output "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  value       = aws_security_group.bastion_sg.id
}

output "ssm_vpce_sg_id" {
  description = "Security Group ID for SSM VPC Endpoints"
  value       = var.enable_ssm_endpoints ? aws_security_group.ssm_vpce[0].id : null
}