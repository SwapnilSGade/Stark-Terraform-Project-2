variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "source_s3_bucket" {
  description = "Existing S3 bucket name"
  type        = string
}

variable "source_s3_prefix" {
  description = "Optional prefix within S3"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "azure_secret_name" {
  description = "Secrets Manager secret name for Azure creds"
  type        = string
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN"
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "EventBridge schedule expression"
  type        = string
  default     = "rate(4 hours)"
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

variable "azure_storage_account_name" {
  description = "Azure storage account name"
  type        = string
  default     = "strakbackupsa"
}

variable "azure_container_name" {
  description = "Azure blob container name"
  type        = string
}

variable "lambda_reserved_concurrency" {
  description = "Reserved concurrency limit for the Lambda function"
  type        = number
  default     = 1
}
