resource "azurerm_resource_group" "backup_rg" {
  name     = var.azure_rg_name
  location = var.azure_location
  tags     = var.tags
}