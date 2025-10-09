variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "workload_identity_pools" {
  description = "Workload Identity pools and providers Map"
  type = map(object({
    pool_id      = string
    display_name = optional(string)
    description  = optional(string)
    disabled     = optional(bool, false)

    # Providers
    providers = optional(map(object({
      provider_id   = string
      display_name  = optional(string)
      description   = optional(string)
      disabled      = optional(bool, false)
      provider_type = string # "oidc", "aws", ou "saml"

      # Attribute mapping e condition
      attribute_mapping   = optional(map(string), {})
      attribute_condition = optional(string)

      # OIDC (GitHub, GitLab, etc)
      oidc_issuer_uri        = optional(string)
      oidc_allowed_audiences = optional(list(string))

      # AWS
      aws_account_id = optional(string)

      # SAML
      saml_idp_metadata_xml = optional(string)
    })), {})
  }))
}