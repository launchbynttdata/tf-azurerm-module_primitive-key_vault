// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "azurerm_client_config" "current" {

}

resource "azurerm_key_vault" "key_vault" {
  name                            = var.key_vault_name
  location                        = var.resource_group.location
  resource_group_name             = var.resource_group.name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  sku_name                        = var.sku_name
  enable_rbac_authorization       = var.enable_rbac_authorization

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []

    content {
      bypass         = network_acls.value.bypass
      default_action = network_acls.value.default_action

      ip_rules      = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
  public_network_access_enabled = var.public_network_access_enabled
  
  # Required by terraform
  dynamic "access_policy" {
    for_each = local.access_policies

    content {
      tenant_id = coalesce(access_policy.value.tenant_id, data.azurerm_client_config.current.tenant_id)
      object_id = access_policy.value.object_id

      key_permissions         = coalescelist(access_policy.value.key_permissions, local.default_key_permissions)
      certificate_permissions = coalescelist(access_policy.value.certificate_permissions, local.default_certificate_permissions)
      storage_permissions     = coalescelist(access_policy.value.storage_permissions, local.default_storage_permissions)
      secret_permissions      = coalescelist(access_policy.value.secret_permissions, local.default_secret_permissions)
    }
  }

  tags = local.tags
}

resource "azurerm_key_vault_certificate" "certs" {
  for_each     = var.certificates
  name         = replace(each.key, "_", "-")
  key_vault_id = azurerm_key_vault.key_vault.id

  certificate {
    contents = filebase64("${path.root}/${each.value.certificate_name}")
    password = each.value.password
  }

  tags = local.tags
}

resource "azurerm_key_vault_secret" "vault_secrets" {
  for_each     = var.secrets
  name         = replace(each.key, "_", "-")
  value        = each.value
  key_vault_id = azurerm_key_vault.key_vault.id

  tags = local.tags
}

resource "azurerm_key_vault_key" "vault_keys" {
  for_each     = var.keys
  name         = replace(each.key, "_", "-")
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = each.value.key_type
  key_size     = each.value.key_size
  key_opts     = each.value.key_opts

  tags = local.tags
}
