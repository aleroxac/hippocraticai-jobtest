resource "google_compute_network" "vpcs" {
  for_each                = var.vpcs

  name                    = each.key
  auto_create_subnetworks = each.value.auto_create_subnetworks
}