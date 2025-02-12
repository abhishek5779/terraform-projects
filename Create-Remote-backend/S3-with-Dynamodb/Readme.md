# Terraform Configuration for VPC with Remote Backend

This Terraform configuration sets up a Virtual Private Cloud (VPC) and manages its state using an S3 bucket and DynamoDB table for remote backend.

## Configuration Details

- **Terraform Block**:
  - Defines the required AWS provider
  - Specifies the remote backend using S3 and DynamoDB

- **Backend Configuration**:
  - S3 bucket for storing state files
  - Encryption enabled for state files
  - State file key name(terraform.tfstate)
  - AWS region
  - DynamoDB table for state locking

- **Provider Configuration**:
  - AWS region

- **Resources**:
  - **VPC**:
    - Create a VPC block and store its state on above mentioned remote backed and lock the state file using Dynamodb.

## Notes

- Ensure that the AWS credentials are configured properly in your environment.
- The S3 bucket name must be globally unique.