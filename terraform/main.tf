data "aws_caller_identity" "current" {}

output "debug" {
  value = data.aws_caller_identity.current
}
