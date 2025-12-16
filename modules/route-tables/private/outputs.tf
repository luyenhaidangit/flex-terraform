########################################
# Private Route Table Outputs
########################################

output "route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "route_table_arn" {
  description = "ARN of the private route table"
  value       = aws_route_table.private.arn
}
