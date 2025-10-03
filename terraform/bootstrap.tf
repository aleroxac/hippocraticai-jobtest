terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}



## ---------- TFSTATE
resource "google_storage_bucket" "tf_state" {
  name          = "hippocraticai-jobtest-${var.project_id}"
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  versioning { enabled = true }
}
