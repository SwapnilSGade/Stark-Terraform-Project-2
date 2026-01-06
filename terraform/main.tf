locals {
  tags = {
    Project     = var.project_name
    Owner       = "DevOps"
    Environment = "prod"
  }
}

# Include modules/files
# AWS
#module "aws" {
  source                     = "./aws"
  project_name               = var.project_name
  source_s3_bucket           = var.source_s3_bucket
  source_s3_prefix           = var.source_s3_prefix
  aws_region                 = var.aws_region
  azure_secret_name          = var.azure_secret_name
  kms_key_arn                = var.kms_key_arn
  schedule_expression        = var.schedule_expression
  lambda_timeout             = var.lambda_timeout
  lambda_memory_mb           = var.lambda_memory_mb
  azure_storage_account_name = var.azure_storage_account_name
  azure_container_name       = var.azure_container_name
}



# Azure resources
module "azure" {
  source                     = "./azure"
  azure_rg_name              = var.azure_rg_name
  azure_location             = var.azure_location
  azure_storage_account_name = var.azure_storage_account_name
  azure_container_name       = var.azure_container_name
  tags                       = local.tags
}


# Lambda + EventBridge (defined in aws/*.tf referencing variables directly)