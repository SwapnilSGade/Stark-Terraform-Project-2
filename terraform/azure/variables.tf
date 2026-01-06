variable "azure_rg_name" {
  description = "Azure resource group name"
  type        = string
}

variable "azure_location" {
  description = "Azure region"
  type        = string
}

variable "azure_storage_account_name" {
  description = "Globally unique storage account name"
  type        = string
}

variable "azure_container_name" {
  description = "Blob container name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}