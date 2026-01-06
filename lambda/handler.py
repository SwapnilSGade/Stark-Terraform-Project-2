import os
import json
import logging
import boto3
from botocore.config import Config
from azure.storage.blob import BlobServiceClient

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
logging.basicConfig(level=getattr(logging, LOG_LEVEL))
logger = logging.getLogger(__name__)

AWS_REGION = os.getenv("AWS_REGION")
SOURCE_S3_BUCKET = os.getenv("SOURCE_S3_BUCKET")
SOURCE_S3_PREFIX = os.getenv("SOURCE_S3_PREFIX", "")
AZURE_SECRET_NAME = os.getenv("AZURE_SECRET_NAME")
AZURE_STORAGE_ACCOUNT_NAME = os.getenv("AZURE_STORAGE_ACCOUNT_NAME")
AZURE_CONTAINER_NAME = os.getenv("AZURE_CONTAINER_NAME")

session = boto3.session.Session(region_name=AWS_REGION)
s3 = session.client("s3", config=Config(retries={"max_attempts": 5, "mode": "standard"}))
secrets = session.client("secretsmanager")

def get_azure_creds():
    # Secret JSON structure example:
    # {
    #   "connection_string": "DefaultEndpointsProtocol=...;AccountName=...;AccountKey=...;EndpointSuffix=core.windows.net"
    # }
    resp = secrets.get_secret_value(SecretId=AZURE_SECRET_NAME)
    secret_str = resp.get("SecretString", "{}")
    data = json.loads(secret_str)
    conn_str = data.get("connection_string")
    if not conn_str:
        raise RuntimeError("Azure connection_string missing in secret")
    return conn_str

def lambda_handler(event, context):
    logger.info("Starting S3 -> Azure Blob sync job")
    if not SOURCE_S3_BUCKET or not AZURE_CONTAINER_NAME or not AZURE_STORAGE_ACCOUNT_NAME:
        raise RuntimeError("Missing required environment variables")

    conn_str = get_azure_creds()
    blob_service = BlobServiceClient.from_connection_string(conn_str)
    container_client = blob_service.get_container_client(AZURE_CONTAINER_NAME)

    paginator = s3.get_paginator("list_objects_v2")
    kwargs = {"Bucket": SOURCE_S3_BUCKET}
    if SOURCE_S3_PREFIX:
        kwargs["Prefix"] = SOURCE_S3_PREFIX

    synced = 0
    for page in paginator.paginate(**kwargs):
        contents = page.get("Contents", [])
        for obj in contents:
            key = obj["Key"]
            # Preserve folder structure under the same blob name
            blob_name = key if not SOURCE_S3_PREFIX else key[len(SOURCE_S3_PREFIX):].lstrip("/")
            if blob_name == "":
                blob_name = key

            logger.debug(f"Syncing object: s3://{SOURCE_S3_BUCKET}/{key} -> blob://{AZURE_CONTAINER_NAME}/{blob_name}")

            # Stream download from S3 and upload to Azure
            s3_obj = s3.get_object(Bucket=SOURCE_S3_BUCKET, Key=key)
            data_stream = s3_obj["Body"]

            # Upload with overwrite; set tier or metadata if needed
            container_client.upload_blob(
                name=blob_name,
                data=data_stream,
                overwrite=True,
            )
            synced += 1

    logger.info(f"Sync completed. Objects synced: {synced}")
    return {"synced": synced}