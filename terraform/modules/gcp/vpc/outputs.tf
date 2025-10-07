output "vpc_ids" {
  description = "VPC ID"
  value       = { for k, v in google_compute_network.vpcs : k => v.id }
}

output "subnet_ids" {
  description = "Subnet ID"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.id }
}

output "nat_ip" {
  description = "NAT name"
  value       = try(google_compute_router_nat.nat[0].name, null)
}
