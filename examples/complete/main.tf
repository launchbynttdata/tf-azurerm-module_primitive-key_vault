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

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  logical_product_family  = var.product_family
  logical_product_service = var.product_service
  region                  = var.region
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  maximum_length          = each.value.max_length
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = module.resource_names["rg"].minimal_random_suffix
  location = var.region

  tags = merge(var.tags, { resource_name = module.resource_names["rg"].standard })

}

module "key_vault" {

  source = "../.."

  key_vault_name = module.resource_names["kv"].minimal_random_suffix
  resource_group = {
    name     = module.resource_group.name
    location = var.region
  }

  sku_name                  = var.sku_name
  enable_rbac_authorization = var.enable_rbac_authorization
  access_policies           = var.access_policies
  certificates              = var.certificates
  secrets                   = var.secrets
  keys                      = var.keys

  custom_tags = merge(var.tags, { resource_name = module.resource_names["kv"].standard })

  depends_on = [module.resource_group]
}

module "key_vault_role_assignment" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/role_assignment/azurerm"
  version = "~> 1.0"

  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  scope                = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
}
