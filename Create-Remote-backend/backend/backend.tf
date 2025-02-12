terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.86.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Resource to create S3 bucket for remote backend (Enables encryption by default)
resource "aws_s3_bucket" "backend-bucket" {
  bucket = "terraform-remote-backend-abhi5779"
  lifecycle {
    prevent_destroy = true
  }
}

#Resource to enable S3 managed server-side encryption on the bucket (If not defined then also, this is the default encryption)
resource "aws_s3_bucket_server_side_encryption_configuration" "backend-bucket-encryption" {
  bucket = aws_s3_bucket.backend-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Resource to enable versioning on the bucket
resource "aws_s3_bucket_versioning" "backend-bucket-versioning" {
  bucket = aws_s3_bucket.backend-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

#Create DynamoDB table to store the state lock
resource "aws_dynamodb_table" "backend-lock" {
  name         = "terraform-remote-backend-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

#Output the bucket name and DNS
output "remote-backend-bucket-name" {
  value = aws_s3_bucket.backend-bucket.bucket
}
output "remote-backend-bucket-dns" {
  value = aws_s3_bucket.backend-bucket.bucket_domain_name
}