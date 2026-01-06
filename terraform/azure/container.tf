resource "azurerm_storage_container" "backup_container" {
  name                  = var.azure_container_name
  storage_account_name  = azurerm_storage_account.backup_sa.name
  container_access_type = "private"
}