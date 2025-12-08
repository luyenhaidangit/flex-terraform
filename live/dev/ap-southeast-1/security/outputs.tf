output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = module.sg.alb_sg_id
}

output "app_sg_id" {
  description = "Security Group ID for App layer"
  value       = module.sg.app_sg_id
}

output "db_sg_id" {
  description = "Security Group ID for Database"
  value       = module.sg.db_sg_id
}

output "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  value       = module.sg.bastion_sg_id
}
