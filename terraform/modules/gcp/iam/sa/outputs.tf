output "service_accounts" {
  description = "Service Accounts Map"
  value = {
    for key, sa in google_service_account.accounts :
    key => {
      email      = sa.email
      name       = sa.name
      account_id = sa.account_id
      unique_id  = sa.unique_id
      member     = "serviceAccount:${sa.email}"
    }
  }
}

output "emails" {
  description = "Service Account email map (key => email)"
  value = {
    for key, sa in google_service_account.accounts :
    key => sa.email
  }
}

output "members" {
  description = "Service Account member bindings (key => serviceAccount:email)"
  value = {
    for key, sa in google_service_account.accounts :
    key => "serviceAccount:${sa.email}"
  }
}
