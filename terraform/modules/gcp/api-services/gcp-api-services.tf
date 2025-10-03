resource "google_project_service" "services" {
  for_each           = var.enable_api_services ? var.api_services_to_be_enabled : []
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
