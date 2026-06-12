variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  nullable    = false
}

variable "gitlab_token" {
  description = "GitLab personal access token with api scope, used for Terraform state locking"
  type        = string
  nullable    = false
}
