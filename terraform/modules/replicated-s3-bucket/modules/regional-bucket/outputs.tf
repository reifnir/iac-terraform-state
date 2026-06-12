output "bucket_id" {
  description = "S3 bucket name / ID"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "notifications_topic_arn" {
  description = "ARN of the SNS topic receiving S3 event notifications for this region"
  value       = aws_sns_topic.bucket_notifications.arn
}
