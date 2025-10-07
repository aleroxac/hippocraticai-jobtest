terraform {
  required_version = ">= 1.13.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.5.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.5.0"
    }
  }

  backend "gcs" {
    bucket = "hippocraticai-jobtest-aleroxac"
    prefix = "envs"
  }
}

provider "google" {
  project = "aleroxac"
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
