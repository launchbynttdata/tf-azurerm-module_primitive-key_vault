output "key_vault_id" {
	value = azurerm_key_vault.key_vault.id
}

output "vault_uri" {
	value = azurerm_key_vault.key_vault.vault_uri
}

output "access_policies_object_ids" {
	value = try(azurerm_key_vault.key_vault.access_policy[*].object_id)
}

output "other_access_policies" {
	value = try(azurerm_key_vault_access_policy.access_policy)
}

output "key_vault_name" {
	value = azurerm_key_vault.key_vault.name
}