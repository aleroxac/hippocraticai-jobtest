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
