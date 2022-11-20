########################################################
## proxy
########################################################

resource "aws_lb" "this" {
  name               = "${var.env}-${var.project_name}-${var.ec2_name}-alb"  
  internal           = var.internal
  load_balancer_type = "application"  
  
  security_groups    = [aws_security_group.this.id]

  subnets            = var.subnet_ids
  # enable_deletion_protection = true

}

resource "aws_lb_listener" "this" {

  count = var.https_yn == true ? 0 : 1

  load_balancer_arn = aws_lb.this.arn
  port = var.listener_port
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "http" {

  count = var.https_yn == true ? 1 : 0
  
  load_balancer_arn = aws_lb.this.arn
  port = var.listener_port
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {  
  count = var.https_yn == true ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}

resource "aws_lb_target_group" "this" {
  name = "${var.env}-${var.project_name}-${var.ec2_name}"
  port = var.target_group_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"

  lifecycle {
    create_before_destroy = true
  }
}

