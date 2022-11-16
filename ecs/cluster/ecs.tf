resource "aws_ecs_cluster" "this" {
  name = "${var.ecs_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}