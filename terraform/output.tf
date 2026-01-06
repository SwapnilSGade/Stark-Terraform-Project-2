output "lambda_function_name" {
  value       = module.aws.lambda_function_name
  description = "Lambda function name from AWS module"
}

output "eventbridge_rule_arn" {
  value       = module.aws.eventbridge_rule_arn
  description = "EventBridge rule ARN from AWS module"
}

output "azure_storage_account_name" {
  value       = module.azure.storage_account_name
  description = "Azure storage account name from Azure module"
}

output "azure_container_name" {
  value       = module.azure.container_name
  description = "Azure blob container name from Azure module"
}