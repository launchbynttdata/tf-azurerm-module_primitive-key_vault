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

locals {
  default_tags = {
    "provisioner" = "Terraform"
    resource_name = var.key_vault_name
  }

  tags = merge(local.default_tags, var.custom_tags)

  default_certificate_permissions = ["List"]

  default_key_permissions = ["List"]

  default_secret_permissions = ["List"]

  default_storage_permissions = ["List"]

  default_access_policy = {
    "default_policy" = {
      object_id = data.azurerm_client_config.current.object_id
      tenant_id = data.azurerm_client_config.current.tenant_id
      certificate_permissions = [
        "Get", "List", "Import", "Update", "ListIssuers", "GetIssuers", "Delete", "Recover", "Purge"
      ]
      key_permissions = [
        "Get", "List", "Delete", "Create", "Purge"
      ]
      secret_permissions = [
        "Get", "List", "Delete", "Set", "Purge"
      ]
      storage_permissions = [
        "Get", "List", "Delete", "Set"
      ]
    }
  }

  access_policies = merge(local.default_access_policy, var.access_policies)
}
