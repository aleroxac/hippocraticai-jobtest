output "custom_roles" {
  description = "Custom roles"
  value       = local.all_roles
}

output "role_ids" {
  description = "Custom Role ID binding Map (key => projects/.../roles/... ou organizations/.../roles/...)"
  value = {
    for key, role in local.all_roles :
    key => role.id
  }
}

output "role_names" {
  description = "Custom Role Map (key => role_name)"
  value = {
    for key, role in local.all_roles :
    key => role.name
  }
}

output "project_roles" {
  description = "Custom roles with Project scope"
  value = {
    for key, role in local.all_roles :
    key => role
    if role.scope == "project"
  }
}

output "organization_roles" {
  description = "Custom Roles with the Organization scope"
  value = {
    for key, role in local.all_roles :
    key => role
    if role.scope == "organization"
  }
}
