resource "google_iam_workload_identity_pool" "pools" {
  for_each = var.workload_identity_pools

  project                   = var.project_id
  workload_identity_pool_id = each.value.pool_id
  display_name              = try(each.value.display_name, null)
  description               = try(each.value.description, null)
  disabled                  = try(each.value.disabled, false)
}
