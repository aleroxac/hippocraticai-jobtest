locals {
  project_bindings = flatten([
    for sa_key, sa in var.service_accounts : [
      for role in try(sa.project_roles, []) : {
        sa_key = sa_key
        role   = role
        email  = google_service_account.accounts[sa_key].email
      }
    ]
  ])
}

resource "google_project_iam_member" "project_roles" {
  for_each = {
    for binding in local.project_bindings :
    "${binding.sa_key}-${binding.role}" => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.email}"
}