output "key_vault_id" {
    value = azurerm_key_vault.key_vault.id
}

output "vault_uri" {
    value = azurerm_key_vault.key_vault.vault_uri
}