locals {
  nat_enabled_subnets = {
    for k, v in var.subnets :
    k => v if try(v.enable_nat, false)
  }
}

resource "google_compute_router" "router" {
  for_each = local.nat_enabled_subnets

  name    = "${try(each.value.nat_name_prefix, each.key)}-router"
  region  = each.value.region
  network = google_compute_network.vpcs[each.value.vpc_name].id
}

resource "google_compute_address" "nat_ip" {
  for_each = local.nat_enabled_subnets

  name   = "${try(each.value.nat_name_prefix, each.key)}-nat-ip"
  region = each.value.region
}

resource "google_compute_router_nat" "nat" {
  for_each = local.nat_enabled_subnets

  name                               = "${try(each.value.nat_name_prefix, each.key)}-nat"
  router                             = google_compute_router.router[each.key].name
  region                             = each.value.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat_ip[each.key].self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnets[each.key].id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
