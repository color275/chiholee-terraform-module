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
      value = lower("${var.app_name}-${var.service_name}")
      type  = "PLAINTEXT"
    }

    environment_variable {
      name  = "V_FAMILY"
      value = "${var.app_name}-${var.service_name}"
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

    
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/${var.app_name}-${var.service_name}/codebuild"
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

