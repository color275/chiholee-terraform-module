output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

# output "alb_sg_id" {
#   value = aws_security_group.alb_sg.id
# }

# output "alb_arn" {
#   value = aws_lb.this.arn
# }

