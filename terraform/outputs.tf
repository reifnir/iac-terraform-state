output "primary_bucket_name" {
  description = "Name of the primary (us-east-1) S3 bucket"
  value       = module.state_bucket.primary_bucket_id
}

output "primary_bucket_arn" {
  description = "ARN of the primary (us-east-1) S3 bucket"
  value       = module.state_bucket.primary_bucket_arn
}

output "secondary_bucket_name" {
  description = "Name of the secondary (us-west-2) S3 bucket"
  value       = module.state_bucket.secondary_bucket_id
}

output "secondary_bucket_arn" {
  description = "ARN of the secondary (us-west-2) S3 bucket"
  value       = module.state_bucket.secondary_bucket_arn
}
