## --- gke
module "gke_cluster_required_api_services" {
  source = "../../modules/gcp/api-services"

  project_id          = var.project_id
  enable_api_services = true
  api_services_to_be_enabled = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
  ])
}

module "gke_cluster_and_node_pool" {
  source = "../../modules/gcp/gke"

  project_id               = var.project_id
  location                 = "us-east1"
  cluster_name             = "hippocraticai-dev"
  network                  = module.vpc.vpc_id
  subnetwork               = module.vpc.subnet_id
  enable_np_autoscaling    = true
  min_node_count           = 1
  max_node_count           = 3
  machine_type             = "e2-standard-4"
  disk_size_gb             = 20
  enable_workload_identity = true

  depends_on = [
    module.vpc,
    module.gke_cluster_required_api_services
  ]
}
