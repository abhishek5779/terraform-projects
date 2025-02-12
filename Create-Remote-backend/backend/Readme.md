# Terraform Remote Backend Configuration

This Terraform configuration sets up a remote backend using AWS S3 and DynamoDB. The S3 bucket is used to store the Terraform state files, and the DynamoDB table is used to manage state locking.

## Prerequisites

- Terraform v0.12 or later
- AWS account with appropriate permissions to create S3 buckets and DynamoDB tables

## Configuration Details

### Providers

- Uses the AWS provider
- AWS region: `us-east-1`

### Resources

- **S3 Bucket**: 
  - An S3 bucket is created to store the Terraform state files
  - Server-side encryption enabled by default
  - Versioning enabled
  - Prevents bucket destruction

- **DynamoDB Table**:
  - A DynamoDB table is created to manage state locking, ensuring that only one process can modify the state at a time.