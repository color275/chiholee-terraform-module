# resource "aws_lb" "this" {
#   name               = "${var.env}-${var.project_name}-${var.service_name}-alb"  
#   internal           = var.lb_internal
#   load_balancer_type = "application"
  
#   subnets            = var.lb_subnet_ids

#   security_groups    = [aws_security_group.alb_sg.id]
# }


resource "aws_lb" "this" {
  name               = "${var.env}-${var.project_name}-${var.service_name}-${var.load_balancer_type == "application" ? "alb" : "nlb"}"  
  internal           = var.lb_internal
  load_balancer_type = var.load_balancer_type
  
  subnets = var.private_ip_yn ? null : var.lb_subnet_ids  

  security_groups            = var.load_balancer_type == "application" ? [aws_security_group.alb_sg[0].id] : null 

  enable_cross_zone_load_balancing = var.load_balancer_type == "application" ? null : true
  

  dynamic "subnet_mapping" {
      for_each = var.private_ip_yn == true ? toset([1]) : toset([])      
      content {
        subnet_id            = var.lb_subnet_ids[0]
        private_ipv4_address = var.private_ip1
      }      
  }

  dynamic "subnet_mapping" {
      for_each = var.private_ip_yn == true ? toset([1]) : toset([])      
      content {
        subnet_id            = var.lb_subnet_ids[1]
        private_ipv4_address = var.private_ip2
      }      
  }
}

resource "aws_lb_listener" "blue_green" {

  count = var.https_yn == true ? 0 : 1

  load_balancer_arn = aws_lb.this.arn
  port              = var.lb_listener_port  
  protocol          = var.load_balancer_type == "application" ? "HTTP" : "TCP"

  depends_on = [
                aws_lb_target_group.blue_target_group,
                aws_lb_target_group.green_target_group
              ]
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_target_group.arn
  }

  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}


resource "aws_lb_listener" "blue_green_http" { 

  count = var.https_yn == true && var.load_balancer_type == "application" ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.lb_listener_port
  protocol          = var.load_balancer_type == "application" ? "HTTP" : "TCP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }  
}

resource "aws_lb_listener" "blue_green_https" {  
  count = var.https_yn == true ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = var.load_balancer_type == "application" ? "HTTPS" : "TLS"
  certificate_arn   = var.certificate_arn

  depends_on = [
                aws_lb_target_group.blue_target_group,
                aws_lb_target_group.green_target_group
              ]
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_target_group.arn
  }

  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}

resource "aws_lb_listener" "test_blue_green" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.lb_test_listener_port
  protocol          = var.load_balancer_type == "application" ? "HTTP" : "TCP"

  depends_on = [
                aws_lb_target_group.blue_target_group,
                aws_lb_target_group.green_target_group
               ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_target_group.arn
  }

  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}


resource "aws_lb_target_group" "blue_target_group" {
  name = "${var.env}-${var.project_name}-${var.service_name}-Blue"  
  port        = var.blue_target_group_port
  protocol    = var.load_balancer_type == "application" ? "HTTP" : "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  preserve_client_ip = ( var.load_balancer_type == "network" ? true : null )

  dynamic "stickiness" {
    for_each =  var.load_balancer_type == "application" ? toset([1]) : toset([])      
      content {
        enabled = true
        type    = "lb_cookie"
      }      
  }

  dynamic "health_check" {
      for_each =  var.load_balancer_type == "application" ? toset([1]) : toset([])      
      content {
        path = var.target_group_health_check_path
        matcher = var.target_group_health_check_macher
      }      
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "green_target_group" {
  name = "${var.env}-${var.project_name}-${var.service_name}-Green"
  port        = var.green_target_group_port
  protocol    = var.load_balancer_type == "application" ? "HTTP" : "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  preserve_client_ip = ( var.load_balancer_type == "network" ? true : null )

  dynamic "stickiness" {
    for_each =  var.load_balancer_type == "application" ? toset([1]) : toset([])      
      content {
        enabled = true
        type    = "lb_cookie"
      }      
  }

  dynamic "health_check" {
      for_each =  var.load_balancer_type == "application" ? toset([1]) : toset([])      
      content {
        path = var.target_group_health_check_path
        matcher = var.target_group_health_check_macher
      }      
  }

  lifecycle {
    create_before_destroy = true
  }
}






