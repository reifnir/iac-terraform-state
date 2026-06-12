# terraform-state

I need a place to keep Terraform state. Don't want to store state in the bucket we're managing here since that makes destorying it a hassle if necessary. So going to store state in Gitlab.

This project creates a terraform state bucket in two regions with bidirectional replication.

It also sets up a few Gitlab variables for other pipelines to consume for Terraform state:

- `TERRAFORM_STATE_BUCKET_PRIMARY`: The S3 bucket name in the primary region
- `TERRAFORM_STATE_BUCKET_SECONDARY`: The S3 bucke name in the secondry region
- `TERRAFORM_STATE_BUCKET_CURRENT`: Currently points to `$TERRAFORM_STATE_BUCKET_PRIMARY`
- `TERRAFORM_REGION_CURRENT`: Currently points to our primary region
