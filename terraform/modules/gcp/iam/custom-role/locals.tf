locals {
  all_roles = merge(
    {
      for key, role in google_project_iam_custom_role.project_roles :
      key => {
        id          = role.id
        name        = role.name
        role_id     = role.role_id
        permissions = role.permissions
        scope       = "project"
      }
    },
    {
      for key, role in google_organization_iam_custom_role.org_roles :
      key => {
        id          = role.id
        name        = role.name
        role_id     = role.role_id
        permissions = role.permissions
        scope       = "organization"
      }
    }
  )
}
