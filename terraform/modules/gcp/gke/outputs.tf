output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.this.name
}

output "cluster_location" {
  description = "Cluster location"
  value       = google_container_cluster.this.location
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.this.endpoint
}

output "master_version" {
  description = "Master version"
  value       = google_container_cluster.this.master_version
}

output "ca_certificate" {
  description = "Custer CA Certificate"
  value       = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "node_pool_name" {
  description = "Pode Pool name"
  value       = google_container_node_pool.default.name
}
