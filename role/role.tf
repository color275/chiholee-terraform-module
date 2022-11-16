resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.this.json

  managed_policy_arns = length(var.policy_arns) == 0 ? null : var.policy_arns
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = var.principals_type
      identifiers = var.principals_identifiers
    }
  }
}