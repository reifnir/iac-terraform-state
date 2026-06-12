data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {}

locals {
  account_name = [
    for account in data.aws_organizations_organization.current.accounts
    : account.name
    if account.id == data.aws_caller_identity.current.account_id
  ][0]

  bucket_name = "${lower(local.account_name)}-terraform-state-primary"
}

module "state_bucket" {
  source = "./modules/replicated-s3-bucket"

  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }

  bucket_name = local.bucket_name
  tags        = var.tags
}
