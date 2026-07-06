locals {
  gitlab_group = "reifnir-public-projects"
}

resource "gitlab_group_variable" "terraform_state_bucket_primary" {
  group             = local.gitlab_group
  key               = "TERRAFORM_STATE_BUCKET_PRIMARY"
  value             = module.state_bucket.primary_bucket_id
  masked            = false
  raw               = true
  environment_scope = "*"
}

resource "gitlab_group_variable" "terraform_state_bucket_secondary" {
  group             = local.gitlab_group
  key               = "TERRAFORM_STATE_BUCKET_SECONDARY"
  value             = module.state_bucket.secondary_bucket_id
  masked            = false
  raw               = true
  environment_scope = "*"
}

resource "gitlab_group_variable" "terraform_state_bucket_current" {
  group             = local.gitlab_group
  key               = "TERRAFORM_STATE_BUCKET_CURRENT"
  value             = "$TERRAFORM_STATE_BUCKET_PRIMARY"
  masked            = false
  raw               = false
  environment_scope = "*"
}

resource "gitlab_group_variable" "terraform_state_region_current" {
  group             = local.gitlab_group
  key               = "TERRAFORM_STATE_REGION_CURRENT"
  value             = "us-east-1"
  masked            = false
  raw               = true
  environment_scope = "*"
}
