resource "aws_iam_role" "bastion_instance_role" {
  count = var.bastion_instance_yn == true ? 1 : 0

  name = "${var.env}-${var.project_name}-bastion-role"

  assume_role_policy = data.aws_iam_policy_document.this.json

  managed_policy_arns = [
    # for session manager 
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "bastion_instance_role" {
  count = var.bastion_instance_yn == true ? 1 : 0

  name = "${var.env}-${var.project_name}-bastion-role"
  role = aws_iam_role.bastion_instance_role[0].name
}
