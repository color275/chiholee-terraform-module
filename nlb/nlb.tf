########################################################
## proxy
########################################################

resource "aws_lb" "this" {
  name               = "${var.app_name}-${var.ec2_name}-nlb"  
  internal           = var.internal
  load_balancer_type = "network"  

  subnets = var.private_ip_yn ? null : var.subnet_ids  

  dynamic "subnet_mapping" {
      for_each = var.private_ip_yn == true ? toset([1]) : toset([])      
      content {
        subnet_id            = var.subnet_ids[0]
        private_ipv4_address = var.private_ip1
      }      
  }

  dynamic "subnet_mapping" {
      for_each = var.private_ip_yn == true ? toset([1]) : toset([])      
      content {
        subnet_id            = var.subnet_ids[1]
        private_ipv4_address = var.private_ip2
      }      
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port = var.listener_port
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name = "${var.app_name}-${var.ec2_name}"
  port = var.target_group_port
  protocol = "TCP"
  vpc_id = var.vpc_id
  target_type = "instance"

  lifecycle {
    create_before_destroy = true
  }
}

