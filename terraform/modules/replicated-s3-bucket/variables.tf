variable "bucket_name" {
  description = "Base name shared by both regional buckets"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
