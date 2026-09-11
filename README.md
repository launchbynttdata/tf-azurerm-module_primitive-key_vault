# tf-azurerm-module_primitive-key_vault

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module creates a `key vault` in `azure` cloud provider. The module is designed to be used as a `primitive` in a `collection` or `reference architecture` module.

## Usage

See [examples/complete](examples/complete) for a full working example.

## Module Development

### Pre-Requisites

The following commands should be available on your system:

- `asdf` or `mise`
- `make`
- `python3` (for pre-commit)

Additionally, your `git` user and email must be configured. Run the `make configure` command from the root of the repository to ensure that you meet these requirements.

### Pre-Commit hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines `pre-commit` hooks for Terraform formatting, validation, documentation generation, and detect-secrets. Hooks are installed when you run `make configure`. Go linting runs via `make lint` in local development and CI, not via pre-commit.

### Terratest examples

Post-deploy tests in `tests/post_deploy_functional/` and `tests/post_deploy_functional_readonly/` target `examples/complete` via an explicit folder constant in each `main_test.go`. Adding another example (for example `examples/minimal`) requires a new test entry point or updating that constant; it is not picked up automatically.

### Local Validation

You should validate the changes you make to any module locally, prior to pushing your changes in a branch to GitHub.

1. Ensure that you have run `make configure` successfully.
2. Ensure you are signed into the appropriate cloud provider (e.g. Azure) for the module under test in your current console session.
3. Run the Terraform and Golang linters:

```
make lint
```

4. Once linters pass, run integration tests (apply, test, destroy):

```
make test
```

The pre-commit validations, as well as the `make lint` and `make test` targets, are performed in CI. Running them locally before opening a PR helps ensure a smooth review.

### Review & Merge Process

Open a Pull Request to the default (`main`) branch. The PR title must follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) format to merge and to drive semantic versioning.

Ensure CI workflows pass, address review feedback, and obtain approvals required by `CODEOWNERS`.

### Automatic Updates

Shared configuration and workflow files are largely managed through [launch-terraform-skeleton](https://github.com/launchbynttdata/launch-terraform-skeleton). Avoid one-off edits to copied skeleton files in this repository unless necessary (for example `.gitignore` entries for generated artifacts). Use `copier check-update` / `copier update` when refreshing from the skeleton.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.67 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_certificate.certs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_key.vault_keys](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.vault_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | Additional Access policies for the vault except the current user which are added by default | <pre>map(object({<br/>    object_id               = string<br/>    tenant_id               = string<br/>    key_permissions         = list(string)<br/>    certificate_permissions = list(string)<br/>    secret_permissions      = list(string)<br/>    storage_permissions     = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | List of certificates to be imported. If `filepath` is specified then the pfx files should be present in the root of the module (path.root). If `content` is specified then the content of the certificate should be provided in base 64 encoded format. Only one of them should be provided. | <pre>map(object({<br/>    contents = optional(string)<br/>    filepath = optional(string)<br/>    password = string<br/>  }))</pre> | `{}` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags for the Key vault | `map(string)` | `{}` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Enable RBAC authorization for the key vault | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | If Azure VM is permitted to retrieve secrets | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | If Azure RM is permitted to retrieve secrets | `bool` | `false` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the key vault | `string` | n/a | yes |
| <a name="input_keys"></a> [keys](#input\_keys) | List of keys to be created in key vault. Name of the key is the key of the map | <pre>map(object({<br/>    key_type = string<br/>    key_size = number<br/>    key_opts = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network ACLs for the key vault | <pre>object({<br/>    bypass                     = string<br/>    default_action             = string<br/>    ip_rules                   = optional(list(string))<br/>    virtual_network_subnet_ids = optional(list(string))<br/>  })</pre> | <pre>{<br/>  "bypass": "AzureServices",<br/>  "default_action": "Allow",<br/>  "ip_rules": [],<br/>  "virtual_network_subnet_ids": []<br/>}</pre> | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether public network access is allowed for this Key Vault. Defaults to true. | `bool` | `true` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | If purge\_protection is enabled | `bool` | `false` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | target resource group resource mask | <pre>object({<br/>    name     = string<br/>    location = string<br/>  })</pre> | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of secrets (name and value) | `map(string)` | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU for the key vault - standard or premium | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Number of retention days for soft delete | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_policies_object_ids"></a> [access\_policies\_object\_ids](#output\_access\_policies\_object\_ids) | n/a |
| <a name="output_certificate_ids"></a> [certificate\_ids](#output\_certificate\_ids) | n/a |
| <a name="output_key_ids"></a> [key\_ids](#output\_key\_ids) | n/a |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_secret_ids"></a> [secret\_ids](#output\_secret\_ids) | n/a |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | n/a |
<!-- END_TF_DOCS -->
