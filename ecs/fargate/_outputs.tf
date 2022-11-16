output "sg_id" {
  value = aws_security_group.sg.id
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}


output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

output "lb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_sg_id" {
  value = try(aws_security_group.alb_sg[0].id, null)
}

# output "blue_green_arn" {
#   value = aws_lb_listener.blue_green.arn
# }

# output "test_blue_green_arn" {
#   value = aws_lb_listener.test_blue_green.arn
# }

# output "blue_target_group_name" {
#   value = aws_lb_target_group.blue_target_group.name
# }

# output "green_target_group_name" {
#   value = aws_lb_target_group.green_target_group.name
# }

