variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  nullable    = false
}

variable "kms_key_arn" {
  description = "ARN of the KMS key (regional primary or replica) used to encrypt this bucket and its log bucket"
  type        = string
  nullable    = false
}
