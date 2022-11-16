resource "aws_codebuild_project" "codeBuild" {
  name          = "${aws_codecommit_repository.this.repository_name}"
  description   = "${aws_codecommit_repository.this.repository_name}"
  # minute
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  dynamic "cache" {
    for_each = var.codebuild_cache_bucket != null ? [1] : []
    content {
      type     = "S3"
      location = var.codebuild_cache_bucket
    }
  }  

  dynamic "vpc_config" {
    for_each = var.vpc_yn == true ? [1] : []

    content {
      vpc_id = var.vpc_id
      subnets = var.subnets
      security_group_ids = var.security_group_ids
    }
  }


  environment {
    compute_type                = var.codebuild_compute_type
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

    environment_variable {
      name  = "V_CONTAINER_NAME"
      value = lower("${var.service_name}-${var.container_name}")
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_FAMILY"
      value = "${var.service_name}-${var.container_name}"
      type  = "PLAINTEXT"
    }    
    
    environment_variable {
      name  = "V_LOG_GROUP"      
      value = "/aws/ecs/${var.ecs_cluster_name}/${var.service_name}-${var.container_name}/"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_ACCOUNT_ID"
      value = var.account_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_DEV_ACCOUNT_ID"
      value = var.dev_account_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_TEST_ACCOUNT_ID"
      value = var.test_account_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_PROD_ACCOUNT_ID"
      value = var.prod_account_id
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_EXECUTION_ROLE_ARN"
      value = "arn:aws:iam::V_ACCOUNT_ID:role/${var.service_name}-${var.container_name}-ecs-execution-role"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_TASK_ROLE_ARN"
      value = "arn:aws:iam::V_ACCOUNT_ID:role/${var.service_name}-${var.container_name}-ecs-task-role"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_REGION_NAME"
      value = var.region
      type  = "PLAINTEXT"
    }
    
    environment_variable {
      name  = "V_REPOSITORY_URL"
      value = aws_ecr_repository.ecr_repository.repository_url
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_TAG_NAME"
      value = "latest"
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_HOST_PORT"
      value = var.host_port
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_CONTAINER_PORT"
      value = var.container_port
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_DEV_CPU"
      value = var.dev_cpu
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_DEV_MEMORY"
      value = var.dev_memory
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_TEST_CPU"
      value = var.test_cpu
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_TEST_MEMORY"
      value = var.test_memory
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_PROD_CPU"
      value = var.prod_cpu
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_PROD_MEMORY"
      value = var.prod_memory
      type  = "PLAINTEXT"
    }
    
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/${var.service_name}-${var.container_name}/codebuild"
      stream_name = ""
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = aws_codecommit_repository.this.clone_url_http
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "main"  

  tags = local.tags_merge
}

