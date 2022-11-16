
resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id
  name_prefix = "${var.service_name}-${var.container_name}-sg"
  tags = {
    Name = "${var.service_name}-${var.container_name}-sg"
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

resource "aws_security_group_rule" "sg1" {
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  cidr_blocks       = var.load_balancer_type == "application" ? null : var.nlb_ingress_rules
  source_security_group_id = var.load_balancer_type == "application" ? aws_security_group.alb_sg[0].id : null
  description       = "alb port"
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "sg2" {
  count             = length(var.ingress_rules)
  type              = "ingress"
  from_port         = var.ingress_rules[count.index][0]
  to_port           = var.ingress_rules[count.index][1]
  protocol          = var.ingress_rules[count.index][2]
  source_security_group_id = var.ingress_rules[count.index][3]
  description       = var.ingress_rules[count.index][4]
  security_group_id = aws_security_group.sg.id
}


resource "aws_security_group" "alb_sg" {

  count = var.load_balancer_type == "application" ? 1 : 0

  vpc_id = var.vpc_id
  name_prefix = "${var.service_name}-${var.container_name}-alb-sg"
  tags = {
    Name = "${var.service_name}-${var.container_name}-alb-sg"
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_sg" {
  count             = length(var.lb_ingress_rules) > 0 && var.load_balancer_type == "application" ? length(var.lb_ingress_rules) : 0
  type              = "ingress"

  from_port         = var.lb_ingress_rules[count.index][0]
  to_port           = var.lb_ingress_rules[count.index][1]
  protocol          = var.lb_ingress_rules[count.index][2]
  cidr_blocks = length(var.lb_ingress_rules[count.index][3]) == 0 ? null : var.lb_ingress_rules[count.index][3]
  source_security_group_id = var.lb_ingress_rules[count.index][4] == "" ? null : var.lb_ingress_rules[count.index][4]
  description       = var.lb_ingress_rules[count.index][5]

  security_group_id = aws_security_group.alb_sg[0].id
}