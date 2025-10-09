locals {
  # Flatten all project-level IAM bindings for service accounts
  sa_project_bindings = flatten([
    for sa_key, sa in var.service_accounts : [
      for role in try(sa.project_roles, []) : {
        key       = "${sa_key}-${replace(role, "/", "-")}"
        sa_email  = "${sa_key}@${var.project_id}.iam.gserviceaccount.com"
        role_full = (
          # If role already includes "projects/", assume it's custom
          startswith(role, "projects/") ? role : role
        )
      }
    ]
  ])
}

# Assign project roles (standard and custom) to each service account
resource "google_project_iam_member" "sa_project_roles" {
  for_each = {
    for binding in local.sa_project_bindings :
    binding.key => binding
  }

  project = var.project_id
  role    = each.value.role_full
  member  = "serviceAccount:${each.value.sa_email}"
}
