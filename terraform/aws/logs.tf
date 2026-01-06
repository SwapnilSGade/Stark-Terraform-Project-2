resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}-s3-to-blob"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn
}