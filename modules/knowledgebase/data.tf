data "aws_caller_identity" "current" {
  count = var.create_default_kb ? 1 : 0
}

data "aws_iam_session_context" "current" {
  count = var.create_default_kb ? 1 : 0
  arn   = data.aws_caller_identity.current[0].arn
}
