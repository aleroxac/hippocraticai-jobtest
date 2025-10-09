variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "service_accounts" {
  description = "Map of service accounts and their IAM configurations."
  type = map(object({
    account_id    = string
    display_name  = optional(string)
    description   = optional(string)
    project_roles = optional(list(string), [])
    iam_members = optional(map(object({
      role   = string
      member = string
    })), {})
  }))
}
