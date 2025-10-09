output "pools" {
  description = "Workload Identity Pools Map"
  value = {
    for key, pool in google_iam_workload_identity_pool.pools :
    key => {
      pool_id        = pool.workload_identity_pool_id
      name           = pool.name
      state          = pool.state
      project_number = var.project_id
    }
  }
}

output "pool_names" {
  description = "Pools names (key => projects/.../workloadIdentityPools/...)"
  value = {
    for key, pool in google_iam_workload_identity_pool.pools :
    key => pool.name
  }
}

output "providers" {
  description = "Workload Identity Providers Map"
  value = {
    for key, provider in google_iam_workload_identity_pool_provider.providers :
    key => {
      provider_id = provider.workload_identity_pool_provider_id
      name        = provider.name
      state       = provider.state
    }
  }
}

output "provider_names" {
  description = "Provider Names (key => projects/.../providers/...)"
  value = {
    for key, provider in google_iam_workload_identity_pool_provider.providers :
    key => provider.name
  }
}

output "github_actions_config" {
  description = "Configurações formatadas para GitHub Actions (se houver provider GitHub)"
  value = {
    for key, provider in google_iam_workload_identity_pool_provider.providers :
    key => {
      workload_identity_provider = provider.name
    }
    if can(regex("github", lower(key)))
  }
}