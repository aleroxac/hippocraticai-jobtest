variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-east1"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "github_repositories" {
  description = "GitHub autorized repositories (format: owner/repo)"
  type        = list(string)
}