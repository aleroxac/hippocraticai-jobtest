resource "google_organization_iam_custom_role" "org_roles" {
  for_each = {
    for key, role in var.custom_roles :
    key => role
    if try(role.scope, "project") == "organization"
  }

  org_id      = var.organization_id
  role_id     = each.value.role_id
  title       = each.value.title
  description = try(each.value.description, "")
  permissions = each.value.permissions
  stage       = try(each.value.stage, "GA")
}
