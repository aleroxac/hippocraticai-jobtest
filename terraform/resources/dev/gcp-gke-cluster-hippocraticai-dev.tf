## --- gke
data "http" "my_ip" {
  url = "https://ifconfig.me/ip"

  # request_headers = {
  #   "User-Agent" = "curl"
  # }
}

locals {
  my_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}


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

  providers = {
    google      = google      # provider default
    google-beta = google-beta # provider beta
  }

  ## --- cluster
  cluster_name            = "hippocraticai-${var.environment}"
  project_id              = var.project_id
  location                = var.region
  network                 = values(module.vpc.vpc_ids)[0]
  subnetwork              = values(module.vpc.subnet_ids)[0]
  release_channel         = "REGULAR"
  enable_private_cluster  = true
  enable_private_endpoint = false
  master_ipv4_cidr_block  = "172.16.0.0/28"
  pods_range_name         = "gke-pods"
  services_range_name     = "gke-services"
  authorized_cidr_blocks = [
    {
      name = "Home"
      cidr = local.my_cidr
    },
    {
      name = "GitHub Actions"
      cidr = "0.0.0.0/0"
    }
  ]

  ## --- node-pool
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
