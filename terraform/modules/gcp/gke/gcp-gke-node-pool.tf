
resource "google_container_node_pool" "default" {
  provider = google

  name       = "${var.cluster_name}-np1"
  cluster    = google_container_cluster.this.name
  location   = var.location
  project    = var.project_id

  node_count = var.enable_np_autoscaling ? null : var.node_count

  dynamic "autoscaling" {
    for_each = var.enable_np_autoscaling ? [1] : []
    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    image_type   = var.image_type

    service_account = var.node_service_account

    oauth_scopes = var.oauth_scopes

    labels = merge({
      "cluster"   = var.cluster_name
      "managedby" = "terraform"
    }, var.node_labels)

    tags = var.node_tags

    metadata = merge({
      disable-legacy-endpoints = "true"
    }, var.node_metadata)

    workload_metadata_config {
      mode = var.enable_workload_identity ? "GKE_METADATA" : "GCE_METADATA"
    }
  }

  depends_on = [google_container_cluster.this]
}
