resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/ecs/${var.ecs_cluster_name}/${var.service_name}-${var.container_name}/"
  retention_in_days = var.retention_in_days
}

