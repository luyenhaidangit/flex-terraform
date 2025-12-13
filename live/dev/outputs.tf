########################################
# Security Groups Outputs
########################################

output "cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = module.cluster_security_groups.cluster_security_group_id
}

output "node_security_group_id" {
  description = "ID of the EKS node security group"
  value       = module.cluster_security_groups.node_security_group_id
}
