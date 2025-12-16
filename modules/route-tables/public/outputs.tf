########################################
# Public Route Table Outputs
########################################

output "route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "route_table_arn" {
  description = "ARN of the public route table"
  value       = aws_route_table.public.arn
}
