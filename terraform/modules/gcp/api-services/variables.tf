variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "enable_api_services" {
  description = "If true, it enables the APIs"
  type        = bool
}

variable "api_services_to_be_enabled" {
  description = "API services to be enabled"
  type = set(string)
}
