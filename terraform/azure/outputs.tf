output "storage_account_name" {
  description = "Azure storage account name"
  value       = azurerm_storage_account.backup_sa.name
}

output "container_name" {
  description = "Azure blob container name"
  value       = azurerm_storage_container.backup_container.name
}