


resource "aws_ecs_service" "this" {
  name            = "${var.service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  # task_definition = null
  # https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/ecs-exec.html
  enable_execute_command = true
  desired_count   = var.desired_count
  launch_type     = "FARGATE"   
  network_configuration {
    security_groups  = concat([aws_security_group.sg.id], var.security_groups)
    subnets            = var.container_subnet_ids
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.blue_target_group.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }  

  

  depends_on = [                
                # aws_lb_listener.blue_green_https[0]
                aws_lb.this
               ]

  deployment_controller {
    type = "CODE_DEPLOY"
  }
  
  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition,
    ]
  }

#   tags = {
#     Environment = "Dev"
#     Application = var.app_name
#   }
}

resource "aws_ecs_task_definition" "this" {
  family = var.container_name
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "blank"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
  cpu                      = ".25 vCPU"
  memory                   = "1 GB"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  lifecycle {
    ignore_changes = [
      cpu,
      memory,
    ]
  }
}


# resource "aws_ecs_task_definition" "this" {
#   family                   = "${var.service_name}"
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 2048
#   requires_compatibilities = ["FARGATE"]
#   container_definitions    = data.template_file.taskdef.rendered  
#   # container_definitions    = "blank"
#   execution_role_arn       = aws_iam_role.ecs_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn
  
# #   tags = {
# #     Environment = "ecs"
# #     Application = var.app_name
# #   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# data "template_file" "taskdef" {
#   template = file(var.taskdef_path)
#   vars = {
#     container_name = var.service_name
#     ecr_repository = var.ecr_repository_url
#     host_port = var.host_port
#     container_port = var.container_port
#     log_group = "/aws/ecs/${var.ecs_cluster_name}/${var.service_name}-${var.container_name}/"
    
#   }
# }



