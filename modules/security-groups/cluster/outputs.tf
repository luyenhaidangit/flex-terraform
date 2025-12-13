########################################
# Cluster Security Group Outputs
########################################

output "cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.cluster.id
}

########################################
# Node Security Group Outputs
########################################

output "node_security_group_id" {
  description = "ID of the EKS node security group"
  value       = aws_security_group.node.id
}
