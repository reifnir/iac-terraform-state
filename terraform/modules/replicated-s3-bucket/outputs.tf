output "kms_key_arn" {
  description = "ARN of the multi-region KMS primary key (us-east-1)"
  value       = aws_kms_key.s3.arn
}

output "kms_replica_key_arn" {
  description = "ARN of the multi-region KMS replica key (us-west-2)"
  value       = aws_kms_replica_key.s3.arn
}

output "primary_bucket_id" {
  description = "Name of the primary (us-east-1) S3 bucket"
  value       = module.primary.bucket_id
}

output "primary_bucket_arn" {
  description = "ARN of the primary (us-east-1) S3 bucket"
  value       = module.primary.bucket_arn
}

output "secondary_bucket_id" {
  description = "Name of the secondary (us-west-2) S3 bucket"
  value       = module.secondary.bucket_id
}

output "secondary_bucket_arn" {
  description = "ARN of the secondary (us-west-2) S3 bucket"
  value       = module.secondary.bucket_arn
}
