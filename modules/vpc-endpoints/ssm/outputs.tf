########################################
# SSM VPC Endpoints Outputs
########################################

output "ssm_endpoint_ids" {
  description = "Map of SSM endpoint IDs (key: endpoint name, value: endpoint ID)"
  value = {
    for k, v in aws_vpc_endpoint.ssm : k => v.id
  }
}

output "ssm_endpoint_dns_entries" {
  description = "Map of SSM endpoint DNS entries"
  value = {
    for k, v in aws_vpc_endpoint.ssm : k => v.dns_entry
  }
}

output "ssm_endpoint_network_interface_ids" {
  description = "Map of SSM endpoint network interface IDs"
  value = {
    for k, v in aws_vpc_endpoint.ssm : k => v.network_interface_ids
  }
}
