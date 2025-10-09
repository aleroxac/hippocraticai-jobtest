variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = null
}

variable "organization_id" {
  description = "Organization ID"
  type        = string
  default     = null
}

variable "custom_roles" {
  description = "Custom Role map"
  type = map(object({
    role_id     = string
    title       = string
    description = optional(string, "")
    permissions = list(string)
    stage       = optional(string, "GA")
    scope       = optional(string, "project") # "project" ou "organization"
  }))
}