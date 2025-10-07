locals {
  name_prefix = "hippocraticai"
  vpc_name    = "${local.name_prefix}-vpc-${var.environment}"
}

module "vpc" {
  source = "../../modules/gcp/vpc"

  vpcs = {
    (local.vpc_name) = {
      auto_create_subnetworks = false
    }
  }

  subnets = {
    hippocraticai-subnet-dev-us-east1-public = {
      vpc_name      = local.vpc_name
      region        = var.region
      ip_cidr_range = "10.0.1.0/24"
      subnet_type   = "public"
      enable_nat    = false
    }

    hippocraticai-subnet-dev-us-east1-private = {
      vpc_name      = local.vpc_name
      region        = var.region
      ip_cidr_range = "10.0.2.0/24"
      subnet_type   = "private"

      enable_nat    = true
      nat_name_prefix = local.name_prefix
      nat_ip_count    = 1

      secondary_ip_ranges = [
        {
          range_name    = "gke-pods"
          ip_cidr_range = "10.10.0.0/16"
        },
        {
          range_name    = "gke-services"
          ip_cidr_range = "10.20.0.0/20"
        }
      ]
    }
  }
}
