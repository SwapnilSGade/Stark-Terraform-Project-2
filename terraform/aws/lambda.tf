resource "aws_lambda_function" "s3_to_blob" {
  function_name = "${var.project_name}-s3-to-blob"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"

  # Corrected path to package.zip (two levels up from aws/)
  filename         = "${path.module}/../../lambda/package.zip"
  source_code_hash = filebase64sha256("${path.module}/../../lambda/package.zip")

  timeout              = var.lambda_timeout
  memory_size          = var.lambda_memory_mb

  environment {
    variables = {
      AZURE_STORAGE_ACCOUNT_NAME = var.azure_storage_account_name
      AZURE_CONTAINER_NAME       = var.azure_container_name
    }
  }

  tags = {
    Project = var.project_name
  }
}