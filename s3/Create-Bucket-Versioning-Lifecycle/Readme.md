# S3 Bucket Configuration with Versioning, Lifecycle Rules, and KMS Encryption

In this project, we will create and configure two S3 buckets with the following features:

- Block public access
- Enable versioning
- Apply lifecycle rules
- Use KMS for server-side encryption

## Steps

1. **Create S3 Buckets**
   - Create two S3 buckets (`labdata-123456` and `lablogs-123456`) with public access blocked and object lock disabled.

2. **Enable Bucket Versioning**
   - Enable versioning for both buckets to keep multiple versions of an object in the same bucket.

3. **Apply Lifecycle Rules**
   - Apply lifecycle rules to transition objects to Glacier storage class after 45 days and delete them after 3652 days.

4. **Create KMS Key for Encryption**
   - Create a symmetric KMS key for server-side encryption of the S3 buckets.

5. **Attach Alias to KMS Key**
   - Attach an alias (`alias/terraform-key`) to the created KMS key for easy reference.

6. **Update Buckets for Server-Side Encryption**
   - Update one of the S3 buckets to use the created KMS key for server-side encryption.

## Lab reference - 
https://learn.acloud.guru/handson/d8590da1-be72-4e06-8a31-2e6e1c9863b6