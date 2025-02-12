#Terrform block to define backend and provider details
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-remote-backend-abhi5779"
    encrypt      = true
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

#Resource to create VPC and manage it's state using S3 and DynamoDB
resource "aws_vpc" "my-vpc2" {
  cidr_block = "10.2.0.0/16"
  tags = {
    "Name" = "myVpc2"
  }
}