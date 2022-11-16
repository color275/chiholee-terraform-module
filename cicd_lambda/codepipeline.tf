

resource "aws_codepipeline" "codePipeline" {
  name     = "${aws_codecommit_repository.this.repository_name}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.source_bucket_name
    type     = "S3"

    encryption_key {
      id   = var.kms_arn      
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      namespace = "SourceVariables"

      configuration = {
        BranchName    = "main"
        PollForSourceChanges = "false"
        RepositoryName       = aws_codecommit_repository.this.repository_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]      
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      namespace = "BuildVariables"

      configuration = {
        ProjectName = aws_codebuild_project.codeBuild.name
      }
    }
  }

  stage {
    name = "Dev-Deploy"  

    action {
      name             = "Code-Pull"
      category         = "Invoke"
      owner            = "AWS"
      provider         = "Lambda"
      version          = "1"      
      
      role_arn = "arn:aws:iam::${var.dev_account_id}:role/${var.lambda_exec_role_name}"
      
      configuration = {        
        FunctionName = var.update_lambda_name
        UserParameters = var.repo_name
      }
    }  

  }

  dynamic "stage" {
    for_each = var.test_approval ? [1] : []
    content {
      name = "Test-Stage-Approval"
      action {
        configuration = {
          NotificationArn = var.sns_arn
          #  https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/reference-variables.html
          CustomData      = "* id : #{SourceVariables.CommitId}\n* message : #{SourceVariables.CommitMessage}"
          ExternalEntityLink = "http://example.com"
        }
        name     = "Test-Stage-Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"
      }
    }
  }

  dynamic "stage" {
    for_each = var.test_approval ? [1] : []
    content {
      name = "Test-Deploy"  
      action {
        name             = "Code-Pull"
        category         = "Invoke"
        owner            = "AWS"
        provider         = "Lambda"
        version          = "1"      
      
        role_arn = "arn:aws:iam::${var.test_account_id}:role/${var.lambda_exec_role_name}"

        configuration = {
          FunctionName = var.update_lambda_name
        UserParameters = var.repo_name
        }
      }  
    }
  }

  dynamic "stage" {
    for_each = var.prod_approval ? [1] : []
    content {
      name = "Product-Stage-Approval"
      action {
        configuration = {
          NotificationArn = var.sns_arn
          #  https://docs.aws.amazon.com/ko_kr/codepipeline/latest/userguide/reference-variables.html
          CustomData      = "* id : #{SourceVariables.CommitId}\n* message : #{SourceVariables.CommitMessage}"
          ExternalEntityLink = "http://example.com"
        }
        name     = "Product-Stage-Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"
      }
    }
  }

  dynamic "stage" {
    for_each = var.prod_approval ? [1] : []
    content {
      name = "Prod-Deploy"  
      action {
        name             = "Code-Pull"
        category         = "Invoke"
        owner            = "AWS"
        provider         = "Lambda"
        version          = "1"      
      
        role_arn = "arn:aws:iam::${var.prod_account_id}:role/${var.lambda_exec_role_name}"

        configuration = {
          FunctionName = var.update_lambda_name
        UserParameters = var.repo_name
        }
      }  
    }
  }

  

 

  tags = local.tags_merge

  depends_on = [aws_iam_policy.assume_policy]

  
}
