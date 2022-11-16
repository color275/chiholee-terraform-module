# resource "aws_lb" "this" {
#   name               = "${var.app_name}-${var.ecs_name}-alb"  
#   internal           = var.lb_internal
#   load_balancer_type = "application"
  
#   subnets            = var.subnet_ids

#   security_groups    = [aws_security_group.alb_sg.id]
# }