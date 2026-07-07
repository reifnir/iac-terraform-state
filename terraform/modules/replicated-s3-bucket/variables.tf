variable "bucket_name" {
  description = "Base name shared by both regional buckets"
  type        = string
  nullable    = false
}

variable "plan_role_names" {
  description = "Names of IAM roles (in any account of the organization) allowed to run terraform plan with S3 state locking: read state and create/delete lock files"
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.plan_role_names) > 0
    error_message = "At least one role name is required; the generated policy statements would be invalid with an empty list."
  }
}
