
#Create a bucket with Public access blocked, Versioning disabled and object lock disabled.
resource "aws_s3_bucket" "bucket1" {
  bucket              = "labdata-123456"
  object_lock_enabled = false
}

resource "aws_s3_bucket" "bucket2" {
  bucket              = "lablogs-123456"
  object_lock_enabled = false
}

#Enable bucket versioning
resource "aws_s3_bucket_versioning" "bucket1-version" {
  bucket = aws_s3_bucket.bucket1.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "bucket2-version" {
  bucket = aws_s3_bucket.bucket2.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Create Lifecycle rule to expire current version object after 3652 days and transition current version objects to Glacier after 45 days
resource "aws_s3_bucket_lifecycle_configuration" "bucket1-lifecycle" {
  bucket = aws_s3_bucket.bucket1.id
  rule {
    id     = "log-expiration"
    status = "Enabled"
    filter {}
    expiration {
      days = 3652
    }
    transition {
      days          = 45
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket2-lifecycle" {
  bucket = aws_s3_bucket.bucket2.id
  rule {
    id     = "log-expiration"
    status = "Enabled"
    filter {}
    expiration {
      days = 3652
    }
    transition {
      days          = 45
      storage_class = "GLACIER"
    }
  }
}

#Assume the identity of the current user and get's its details like arn and account id
data "aws_caller_identity" "current" {}


#Create a KMS key for server side encryption using symmetric key - same key will be used for encryption & decryption
resource "aws_kms_key" "example" {
  description             = "An example symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloud_user"
        },
        Action = [
          "kms:ReplicateKey",
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloud_user"
        },
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        Resource = "*"
      }
    ]
  })
}

#Attaching an Alias to the above created KMS Key for easy reference
resource "aws_kms_alias" "key-alias" {
  name          = "alias/terraform-key"
  target_key_id = aws_kms_key.example.key_id
}

#Updating the bucket to use the above created KMS key for server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket1-encryption" {
    bucket = aws_s3_bucket.bucket1.id
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.example.arn
        sse_algorithm = "aws:kms"
      }
      bucket_key_enabled = true
    }
}