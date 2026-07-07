data "aws_caller_identity" "current" {
  provider = aws.primary
}

data "aws_partition" "current" {
  provider = aws.primary
}

data "aws_organizations_organization" "current" {
  provider = aws.primary
}
