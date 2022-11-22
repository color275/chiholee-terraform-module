data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.env}-${var.project_name}-${var.ec2_name}-ec2-role"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = "${var.env}-${var.project_name}-${var.ec2_name}-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.this.json

  # managed_policy_arns = [
  #                         "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",                          
  #                       ]  
  
  managed_policy_arns = var.managed_policy_arns
}




