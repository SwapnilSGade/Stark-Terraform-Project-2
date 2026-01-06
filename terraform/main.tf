########################################
# Local values
########################################
locals {
  tags = {
    Project     = var.project_name
    Owner       = "DevOps"
    Environment = "prod"
  }
}

########################################
# AWS Module
########################################
module "aws" {
  source                     = "./aws"

  # Core project settings
  project_name               = var.project_name
  aws_region                 = var.aws_region

  # S3 source bucket
  source_s3_bucket           = var.source_s3_bucket
  source_s3_prefix           = var.source_s3_prefix

  # Lambda + EventBridge
  schedule_expression        = var.schedule_expression
  lambda_timeout             = var.lambda_timeout
  lambda_memory_mb           = var.lambda_memory_mb
  lambda_reserved_concurrency = var.lambda_reserved_concurrency

  # Secrets + KMS
  azure_secret_name          = var.azure_secret_name
  kms_key_arn                = var.kms_key_arn

  # Azure target storage (needed by Lambda sync logic)
  azure_storage_account_name = var.azure_storage_account_name
  azure_container_name       = var.azure_container_name

  # Tags (optional, if your AWS module supports them)
  tags                       = local.tags
}

########################################
# Azure Module
########################################
module "azure" {
  source                     = "./azure"

  # Resource group + location
  azure_rg_name              = var.azure_rg_name
  azure_location             = var.azure_location

  # Storage account + container
  azure_storage_account_name = var.azure_storage_account_name
  azure_container_name       = var.azure_container_name

  # Tags
  tags                       = local.tags
}