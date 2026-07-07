# ── Multi-region KMS key ──────────────────────────────────────────────────────
#
# A single logical key with the same key material in both regions.
# The primary lives in us-east-1; the replica mirrors it in us-west-2.

# Shared by the primary key and its replica: replica keys do not inherit the
# primary's policy, and without an explicit one they fall back to the default
# policy, which would not grant the org plan roles access in the secondary
# region.
data "aws_iam_policy_document" "kms_key" {
  provider = aws.primary

  statement {
    sid    = "EnableRootAccountFullAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowS3ServiceUse"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSNSServiceUse"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions   = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowOrgPlanRolesUse"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = local.plan_role_arn_patterns
    }
  }
}

resource "aws_kms_key" "s3" {
  provider                = aws.primary
  description             = "Multi-region CMK for S3 bucket ${var.bucket_name}"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  multi_region            = true

  policy = data.aws_iam_policy_document.kms_key.json
}

resource "aws_kms_alias" "s3_primary" {
  provider      = aws.primary
  name          = "alias/${var.bucket_name}"
  target_key_id = aws_kms_key.s3.key_id
}

resource "aws_kms_replica_key" "s3" {
  provider                = aws.secondary
  primary_key_arn         = aws_kms_key.s3.arn
  description             = "Replica of multi-region CMK for S3 bucket ${var.bucket_name}"
  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.kms_key.json
}

resource "aws_kms_alias" "s3_secondary" {
  provider      = aws.secondary
  name          = "alias/${var.bucket_name}"
  target_key_id = aws_kms_replica_key.s3.key_id
}
