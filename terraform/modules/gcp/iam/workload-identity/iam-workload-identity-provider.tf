locals {
  providers_flat = flatten([
    for pool_key, pool in var.workload_identity_pools : [
      for provider_key, provider in try(pool.providers, {}) : {
        pool_key     = pool_key
        provider_key = provider_key
        pool_id      = pool.pool_id
        
        provider_id         = provider.provider_id
        display_name        = try(provider.display_name, null)
        description         = try(provider.description, null)
        disabled            = try(provider.disabled, false)
        provider_type       = provider.provider_type
        attribute_mapping   = try(provider.attribute_mapping, {})
        attribute_condition = try(provider.attribute_condition, null)
        
        # OIDC
        oidc_issuer_uri        = try(provider.oidc_issuer_uri, null)
        oidc_allowed_audiences = try(provider.oidc_allowed_audiences, null)
        
        # AWS
        aws_account_id = try(provider.aws_account_id, null)
        
        # SAML
        saml_idp_metadata_xml = try(provider.saml_idp_metadata_xml, null)
      }
    ]
  ])
}

resource "google_iam_workload_identity_pool_provider" "providers" {
  for_each = {
    for provider in local.providers_flat :
    "${provider.pool_key}-${provider.provider_key}" => provider
  }

  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.pools[each.value.pool_key].workload_identity_pool_id
  workload_identity_pool_provider_id = each.value.provider_id
  display_name                       = each.value.display_name
  description                        = each.value.description
  disabled                           = each.value.disabled

  attribute_mapping   = each.value.attribute_mapping
  attribute_condition = each.value.attribute_condition

  # OIDC Configuration
  dynamic "oidc" {
    for_each = each.value.provider_type == "oidc" ? [1] : []
    content {
      issuer_uri        = each.value.oidc_issuer_uri
      allowed_audiences = each.value.oidc_allowed_audiences
    }
  }

  # AWS Configuration
  dynamic "aws" {
    for_each = each.value.provider_type == "aws" ? [1] : []
    content {
      account_id = each.value.aws_account_id
    }
  }

  # SAML Configuration
  dynamic "saml" {
    for_each = each.value.provider_type == "saml" ? [1] : []
    content {
      idp_metadata_xml = each.value.saml_idp_metadata_xml
    }
  }

  depends_on = [google_iam_workload_identity_pool.pools]
}