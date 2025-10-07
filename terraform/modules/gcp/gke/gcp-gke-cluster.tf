resource "google_container_cluster" "this" {
  provider = google-beta

  name                = var.cluster_name
  location            = var.location
  project             = var.project_id
  deletion_protection = false

  network    = var.network
  subnetwork = var.subnetwork

  # We can't create a cluster with no node pool defined, but we want to only use separately managed node pools. 
  # So we create the smallest possible default # node pool and immediately delete it.
  node_pool_defaults {}
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = var.release_channel
  }

  logging_config {
    enable_components = var.logging_components
  }

  monitoring_config {
    enable_components = var.monitoring_components
  }

  maintenance_policy {
    recurring_window {
      start_time = var.maintenance_start_time
      end_time   = var.maintenance_end_time
      recurrence = var.maintenance_recurrence
    }
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_cluster
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.enable_private_cluster ? var.master_ipv4_cidr_block : null
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.enable_private_cluster ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.authorized_cidr_blocks
        content {
          cidr_block   = cidr_blocks.value.cidr
          display_name = cidr_blocks.value.name
        }
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.enable_private_cluster ? var.pods_range_name : null
    services_secondary_range_name = var.enable_private_cluster ? var.services_range_name : null
  }

  dynamic "workload_identity_config" {
    for_each = var.enable_workload_identity ? [1] : []
    content {
      workload_pool = "${var.project_id}.svc.id.goog"
    }
  }
}
