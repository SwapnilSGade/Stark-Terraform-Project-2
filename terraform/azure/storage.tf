resource "azurerm_storage_account" "backup_sa" {
  name                     = var.azure_storage_account_name
  resource_group_name      = azurerm_resource_group.backup_rg.name
  location                 = azurerm_resource_group.backup_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true
  min_tls_version           = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}