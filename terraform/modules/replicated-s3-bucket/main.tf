locals {
  # Matches the given roles in every account of the organization; combined with
  # the aws:PrincipalOrgID condition wherever these are used, only org members
  # can match.
  plan_role_arn_patterns = [
    for name in var.plan_role_names
    : "arn:${data.aws_partition.current.partition}:iam::*:role/${name}"
  ]
}

# ── Regional buckets ──────────────────────────────────────────────────────────

module "primary" {
  source = "./modules/regional-bucket"
  providers = {
    aws = aws.primary
  }

  bucket_name     = "${var.bucket_name}-primary"
  kms_key_arn     = aws_kms_key.s3.arn
  plan_role_names = var.plan_role_names
}

module "secondary" {
  source = "./modules/regional-bucket"
  providers = {
    aws = aws.secondary
  }

  bucket_name     = "${var.bucket_name}-secondary"
  kms_key_arn     = aws_kms_replica_key.s3.arn
  plan_role_names = var.plan_role_names
}
