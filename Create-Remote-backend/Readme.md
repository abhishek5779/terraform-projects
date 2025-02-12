# Terraform Configuration for VPC with Remote Backend and Locking Mechanism

This project demonstrates how to configure Terraform to use an S3 bucket for storing state files and DynamoDB for state locking. The project includes:

- Setting up an S3 bucket as the remote backend for Terraform state files.
- Configuring DynamoDB for state locking to prevent concurrent operations.
- Creating a VPC and managing its state using the following methods:
    - S3 as the remote backend and DynamoDB for state locking.
    - S3 as the remote backend and also for state locking.

Follow the steps in this project to ensure a reliable and consistent Terraform workflow with remote state management and locking mechanisms.