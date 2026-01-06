data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
  tags               = { Project = var.project_name }
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Least-privilege S3 read for a specific bucket/prefix
data "aws_iam_policy_document" "s3_readonly" {
  statement {
    sid     = "ListBucket"
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.source_s3_bucket}"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:prefix"
      values   = [var.source_s3_prefix]
    }
  }

  statement {
    sid     = "GetObjects"
    actions = ["s3:GetObject"]
    resources = [
      var.source_s3_prefix == "" ?
      "arn:aws:s3:::${var.source_s3_bucket}/*" :
      "arn:aws:s3:::${var.source_s3_bucket}/${var.source_s3_prefix}*"
    ]
  }
}

resource "aws_iam_policy" "s3_readonly_policy" {
  name   = "${var.project_name}-s3-readonly"
  policy = data.aws_iam_policy_document.s3_readonly.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_readonly" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}

# CloudWatch and VPC basic permissions
data "aws_iam_policy_document" "lambda_basic_exec" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_basic_exec" {
  name   = "${var.project_name}-lambda-basic-exec"
  policy = data.aws_iam_policy_document.lambda_basic_exec.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_basic_exec.arn
}

# Secrets Manager read-only for Azure creds
data "aws_iam_policy_document" "secrets_read" {
  statement {
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = ["arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.azure_secret_name}-*"]
  }
}

resource "aws_iam_policy" "secrets_read" {
  name   = "${var.project_name}-secrets-read"
  policy = data.aws_iam_policy_document.secrets_read.json
}

resource "aws_iam_role_policy_attachment" "lambda_secrets_read" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.secrets_read.arn
}