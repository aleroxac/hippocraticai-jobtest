data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

locals {
  my_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}



## --- api-services
module "gke_cluster_required_api_services" {
  source = "../../modules/gcp/api-services"

  project_id          = var.project_id
  enable_api_services = true
  api_services_to_be_enabled = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    # Used for workload Identity Federation between Github and GKE
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])
}



## --- iam
module "github_actions_iam_custom_role" {
  source = "../../modules/gcp/iam/custom-role"

  project_id = var.project_id

  custom_roles = {
    "github-actions-custom-role" = {
      role_id     = "githubActionsCustomRole"
      title       = "GitHub Actions Custom Role"
      description = "GitHub Actions Custom Role"
      permissions = [
        # Cluster access
        "container.clusters.get",
        "container.clusters.getCredentials",
        "container.clusters.list",

        # Pods
        "container.pods.get",
        "container.pods.list",
        "container.pods.create",
        "container.pods.update",
        "container.pods.delete",

        # Deployments
        "container.deployments.get",
        "container.deployments.list",
        "container.deployments.create",
        "container.deployments.update",
        "container.deployments.delete",

        # ReplicaSets
        "container.replicaSets.get",
        "container.replicaSets.list",

        # Services
        "container.services.get",
        "container.services.list",
        "container.services.create",
        "container.services.update",
        "container.services.delete",

        # ConfigMaps
        "container.configMaps.get",
        "container.configMaps.list",
        "container.configMaps.create",
        "container.configMaps.update",
        "container.configMaps.delete",

        # Secrets
        "container.secrets.get",
        "container.secrets.list",
        "container.secrets.create",
        "container.secrets.update",
        "container.secrets.delete",

        # Namespaces
        "container.namespaces.get",
        "container.namespaces.getStatus",
        "container.namespaces.list",
        "container.namespaces.create",

        # Service Accounts (K8s)
        "container.serviceAccounts.get",
        "container.serviceAccounts.list",

        # Ingress
        "container.ingresses.get",
        "container.ingresses.list",
        "container.ingresses.create",
        "container.ingresses.update",
        "container.ingresses.delete",

        # HorizontalPodAutoscaler
        "container.horizontalPodAutoscalers.create",
        "container.horizontalPodAutoscalers.get",
        "container.horizontalPodAutoscalers.getStatus",
        "container.horizontalPodAutoscalers.list",
        "container.horizontalPodAutoscalers.update",
        "container.horizontalPodAutoscalers.updateStatus",
      ]
      stage = "GA"
      scope = "project"
    }
  }

  depends_on = [
    module.gke_cluster_required_api_services
  ]
}

module "github_actions_iam_workload_identity" {
  source = "../../modules/gcp/iam/workload-identity"

  project_id = var.project_id

  workload_identity_pools = {
    "github-pool" = {
      pool_id      = "github-pool"
      display_name = "GitHub Actions Pool"
      description  = "Workload Identity Pool for GitHub Actions"

      providers = {
        "github-provider" = {
          provider_id   = "github-provider"
          display_name  = "GitHub OIDC Provider"
          description   = "OIDC provider for GitHub Actions"
          provider_type = "oidc"

          oidc_issuer_uri = "https://token.actions.githubusercontent.com"

          attribute_mapping = {
            "google.subject"             = "assertion.sub"
            "attribute.actor"            = "assertion.actor"
            "attribute.repository"       = "assertion.repository"
            "attribute.repository_owner" = "assertion.repository_owner"
            "attribute.ref"              = "assertion.ref"
          }

          # Optional: Restrict by organization/user
          # attribute_condition = "assertion.repository_owner == 'your-org'"

          # Optional: Restrict by repo
          # attribute_condition = "assertion.repository == 'your-org/your-repo'"

          # Optional: Restrict by branch
          # attribute_condition = "assertion.repository_owner == 'your-org' && assertion.ref == 'refs/heads/main'"
        }
      }
    }
  }

  depends_on = [
    module.gke_cluster_required_api_services
  ]
}

module "github_actions_iam_service_account" {
  source = "../../modules/gcp/iam/sa"

  project_id = var.project_id

  service_accounts = {
    "github-actions" = {
      account_id   = "github-actions"
      display_name = "GitHub Actions"
      description  = "GitHub Actions"

      project_roles = [
        ## artifact-registry
        "roles/artifactregistry.writer",
        "roles/storage.objectViewer",


        ## kubectl & helm
        "projects/${var.project_id}/roles/githubActionsCustomRole",
        # "roles/container.developer",
        # "roles/container.clusterViewer",
      ]

      iam_members = {
        for repo in var.github_repositories :
        replace(repo, "/", "-") => {
          role   = "roles/iam.workloadIdentityUser"
          member = "principalSet://iam.googleapis.com/${module.github_actions_iam_workload_identity.pool_names["github-pool"]}/attribute.repository/${repo}"
        }
      }
    }
  }

  depends_on = [
    module.github_actions_iam_custom_role,
    module.github_actions_iam_workload_identity
  ]
}

# resource "google_project_iam_member" "github_actions_custom_role" {
#   project = var.project_id
#   role    = module.github_actions_iam_custom_role.role_ids["github-actions-custom-role"]
#   member  = module.github_actions_iam_service_account.members["github-actions"]

#   depends_on = [
#     module.github_actions_iam_custom_role,
#     module.github_actions_iam_service_account
#   ]
# }



## --- gke
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
