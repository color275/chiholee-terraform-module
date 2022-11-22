resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/ecs/${var.ecs_cluster_name}/${var.env}-${var.project_name}-${var.service_name}/"
  retention_in_days = var.retention_in_days
}

