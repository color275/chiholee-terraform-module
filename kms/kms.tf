resource "aws_kms_key" "this" {
  description             = "${var.name}"
  deletion_window_in_days = 10
  policy = var.policy
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id    
}

