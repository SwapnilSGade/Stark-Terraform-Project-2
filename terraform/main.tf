locals {
  tags = {
    Project     = var.project_name
    Owner       = "DevOps"
    Environment = "prod"
  }
}

# Include modules/files
# AWS
module "aws_iam" {
  source = "./aws"
}

# Azure resources
module "azure" {
  source                      = "./azure"
  azure_rg_name               = var.azure_rg_name
  azure_location              = var.azure_location
  azure_storage_account_name  = var.azure_storage_account_name
  azure_container_name        = var.azure_container_name
  tags                        = local.tags
}

# Lambda + EventBridge (defined in aws/*.tf referencing variables directly)
