variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "s3-azure-backup"
}

variable "aws_region" {
  description = "AWS region for Lambda and EventBridge"
  type        = string
  default     = "ap-south-1"
}

variable "source_s3_bucket" {
  description = "Existing S3 bucket name to read from"
  type        = string
  default     = "strak-digital"
}

variable "source_s3_prefix" {
  description = "Optional prefix within S3 to scope the sync"
  type        = string
  default     = ""
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "azure_subscription_id"
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = "azure azure_tenant_id"
}

variable "azure_location" {
  description = "Azure region for the storage account"
  type        = string
  default     = "East US"
}

variable "azure_rg_name" {
  description = "Azure resource group name"
  type        = string
  default     = "rg-s3-azure-backup"
}

variable "azure_storage_account_name" {
  description = "Globally unique storage account name"
  type        = string
  default     = "strakbackupsa"
}

variable "azure_container_name" {
  description = "Blob container name for backups"
  type        = string
  default     = "s3backup"
}

variable "azure_secret_name" {
  description = "AWS Secrets Manager secret name storing Azure creds (JSON)"
  type        = string
  default     = "azure-blob-credentials"
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 900
}

variable "lambda_memory_mb" {
  description = "Lambda memory in MB"
  type        = number
  default     = 1024
}

variable "lambda_reserved_concurrency" {
  description = "Reserved concurrency limit for the Lambda function"
  type        = number
  default     = 1
}

variable "schedule_expression" {
  description = "EventBridge schedule expression"
  type        = string
  default     = "rate(4 hours)"
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN for encrypting logs/environment"
  type        = string
  default     = null
}
