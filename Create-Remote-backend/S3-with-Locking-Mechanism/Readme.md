# Terraform Configuration for VPC with Remote Backend and Locking Mechanism

This Terraform configuration sets up a Virtual Private Cloud (VPC) and manages its state using an S3 bucket with a locking mechanism enabled in itself.
Here we are trying the new feature of terraform where it's allowing us to enable the locking mechanism in S3 itself.

## Prerequisites

- Terraform v1.10.0 onwards
- AWS account with appropriate permissions to create S3 buckets and DynamoDB tables

## Configuration Details

- **Terraform Block**:
  - Defines the required AWS provider
  - Specifies the remote backend using S3 with state file encryption and locking mechanism(using S3 itself).

- **Backend Configuration**:
  - S3 bucket for storing state files
  - Encryption enabled for state files
  - State file key
  - AWS region
  - Locking mechanism enabled

- **Provider Configuration**:
  - AWS region

- **Resources**:
  - **VPC**:
    - Create a VPC block and store its state on above mentioned remote backed and lock the state file using S3 only.

## Notes

- Ensure that the AWS credentials are configured properly in your environment.
- The S3 bucket name must be globally unique.