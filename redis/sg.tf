resource "aws_security_group" "this" {
  vpc_id = var.vpc_id
  name_prefix = "${var.service_name}-redis-sg"
  tags = {
    Name = "${var.service_name}-redis-sg"
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group_rule" "this" {
  count             = length(var.ingress_rules)
  type              = "ingress"
  from_port         = var.ingress_rules[count.index][0]
  to_port           = var.ingress_rules[count.index][1]
  protocol          = var.ingress_rules[count.index][2]
  cidr_blocks = length(var.ingress_rules[count.index][3]) == 0 ? null : var.ingress_rules[count.index][3]
  source_security_group_id = var.ingress_rules[count.index][4] == "" ? null : var.ingress_rules[count.index][4]
  description       = var.ingress_rules[count.index][5]
  security_group_id = aws_security_group.this.id
}

