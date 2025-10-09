resource "google_service_account" "accounts" {
  for_each = var.service_accounts

  account_id   = each.value.account_id
  display_name = lookup(each.value, "display_name", null)
  description  = lookup(each.value, "description", null)
}