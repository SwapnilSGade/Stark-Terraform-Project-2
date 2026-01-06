# Cross-cloud backup: AWS S3 to Azure Blob via Lambda + EventBridge

## Purpose
**Goal:** Sync data from an existing AWS S3 bucket to Azure Blob Storage every 4 hours using a serverless, secure, and production-oriented approach.

## Architecture
- **Compute:** AWS Lambda runs a Python sync job.
- **Schedule:** AWS EventBridge triggers Lambda on a `rate(4 hours)` schedule.
- **Source:** Existing AWS S3 bucket (read-only IAM, prefix-aware).
- **Destination:** Azure Storage Account with a private Blob container.
- **Secrets:** Azure connection string stored in AWS Secrets Manager (no hardcoding).
- **Observability:** CloudWatch log group, retries, structured logging.

## Security
- **Least privilege:** Lambda IAM policy limited to `s3:ListBucket` and `s3:GetObject` on the specified bucket/prefix.
- **Secrets at rest:** Azure connection string stored in AWS Secrets Manager; Lambda reads it at runtime.
- **Encryption:** Azure Storage enforces encryption at rest; HTTPS required; min TLS 1.2; optional CloudWatch logs encryption via KMS.
- **No credentials in code:** All secrets passed via Secrets Manager/environment variables.

## Assumptions
- You already have an S3 bucket; we do not create it.
- Azure admin privileges exist to create Storage Account and Container.
- A suitable Azure connection string has been generated and placed in Secrets Manager:
  ```json
  { "connection_string": "DefaultEndpointsProtocol=...;AccountName=...;AccountKey=...;EndpointSuffix=core.windows.net" }