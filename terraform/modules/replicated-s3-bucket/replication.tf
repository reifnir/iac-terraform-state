# ── IAM replication roles (IAM is global; created via aws.primary) ────────────

data "aws_iam_policy_document" "replication_trust" {
  provider = aws.primary

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# We could make a single role for both directions, but separate roles conforms
# better to the principle of least privilege and allows for more granular
# permissions if needed in the future.
resource "aws_iam_role" "primary_to_secondary" {
  provider           = aws.primary
  name               = "${var.bucket_name}-repl-primary-to-secondary"
  assume_role_policy = data.aws_iam_policy_document.replication_trust.json
}

resource "aws_iam_role_policy" "primary_to_secondary" {
  provider = aws.primary
  name     = "replication"
  role     = aws_iam_role.primary_to_secondary.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
        Resource = module.primary.bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
        Resource = "${module.primary.bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
        ]
        Resource = "${module.secondary.bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "kms:Decrypt"
        Resource = aws_kms_key.s3.arn
      },
      {
        Effect   = "Allow"
        Action   = "kms:GenerateDataKey"
        Resource = aws_kms_replica_key.s3.arn
      },
    ]
  })
}

resource "aws_iam_role" "secondary_to_primary" {
  provider           = aws.primary
  name               = "${var.bucket_name}-repl-secondary-to-primary"
  assume_role_policy = data.aws_iam_policy_document.replication_trust.json
}

resource "aws_iam_role_policy" "secondary_to_primary" {
  provider = aws.primary
  name     = "replication"
  role     = aws_iam_role.secondary_to_primary.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
        Resource = module.secondary.bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
        Resource = "${module.secondary.bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
        ]
        Resource = "${module.primary.bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "kms:Decrypt"
        Resource = aws_kms_replica_key.s3.arn
      },
      {
        Effect   = "Allow"
        Action   = "kms:GenerateDataKey"
        Resource = aws_kms_key.s3.arn
      },
    ]
  })
}

# ── Replication configurations ────────────────────────────────────────────────

resource "aws_s3_bucket_replication_configuration" "primary_to_secondary" {
  provider   = aws.primary
  bucket     = module.primary.bucket_id
  role       = aws_iam_role.primary_to_secondary.arn
  depends_on = [module.primary, module.secondary]

  rule {
    id       = "replicate-all-to-secondary"
    status   = "Enabled"
    priority = 0

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = module.secondary.bucket_arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = aws_kms_replica_key.s3.arn
      }

      # We want the SLA for replication to be 15 minutes, so we enable Replication Time Control (RTC) and set the time to 15 minutes. This is a paid feature, but it ensures that replication occurs within the SLA.
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }

      metrics {
        status = "Enabled"
        event_threshold {
          minutes = 15
        }
      }
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "secondary_to_primary" {
  provider   = aws.secondary
  bucket     = module.secondary.bucket_id
  role       = aws_iam_role.secondary_to_primary.arn
  depends_on = [module.primary, module.secondary]

  rule {
    id       = "replicate-all-to-primary"
    status   = "Enabled"
    priority = 0

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = module.primary.bucket_arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = aws_kms_key.s3.arn
      }

      # We want the SLA for replication to be 15 minutes, so we enable Replication Time Control (RTC) and set the time to 15 minutes. This is a paid feature, but it ensures that replication occurs within the SLA.
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }

      metrics {
        status = "Enabled"
        event_threshold {
          minutes = 15
        }
      }
    }
  }
}
