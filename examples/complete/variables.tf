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

variable "product_family" {
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  type        = string
  default     = "dso"
}

variable "product_service" {
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  type        = string
  default     = "kube"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  type        = string
  default     = "eastus"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    rg = {
      name       = "rg"
      max_length = 60
    }
    kv = {
      name       = "kv"
      max_length = 24
    }
    msi = {
      name       = "msi"
      max_length = 60
    }
  }
}

variable "sku_name" {
  description = "SKU for the key vault - standard or premium"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Custom tags for the Key vault"
  type        = map(string)
  default     = {}
}

variable "access_policies" {
  description = "Additional Access policies for the vault except the current user which are added by default"
  type = map(object({
    object_id               = string
    tenant_id               = string
    key_permissions         = list(string)
    certificate_permissions = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
  }))

  default = {}
}

variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization for the key vault"
  type        = bool
  default     = false
}

# Variables to import pre existing certificates to the key vault
# variable "certificates" {
#   description = "List of certificates to be imported. The pfx files should be present in the root of the module (path.root) and its name denoted as certificate_name"
#   type = map(object({
#     certificate_name = string
#     password         = string
#   }))

#   default = {}
# }

variable "certificates" {
  description = "List of certificates to be imported. If `filepath` is specified then the pfx files should be present in the root of the module (path.root). If `content` is specified then the content of the certificate should be provided in base 64 encoded format. Only one of them should be provided."
  type = map(object({
    contents = optional(string)
    filepath = optional(string)
    password = string
  }))

  default = {}
}

# Variables to import secrets
variable "secrets" {
  description = "List of secrets (name and value)"
  type        = map(string)
  default     = {}
}

# Variables to import Keys
variable "keys" {
  description = "List of keys to be created in key vault. Name of the key is the key of the map"
  type = map(object({
    key_type = string
    key_size = number
    key_opts = list(string)
  }))
  default = {}
}
