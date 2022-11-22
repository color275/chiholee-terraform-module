// AWS Codedeploy apps defintion for each module
resource "aws_codedeploy_app" "main" {
  compute_platform = "ECS"
  name             = "${var.env}-${var.project_name}-${var.service_name}"
}

// AWS Codedeploy Group for each codedeploy app created
resource "aws_codedeploy_deployment_group" "main" {
  count = 1
  app_name               = aws_codedeploy_app.main.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.env}-${var.project_name}-${var.service_name}-codedeploy-group"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      # action_on_timeout = "CONTINUE_DEPLOYMENT"
      # action_on_timeout = "STOP_DEPLOYMENT"
      action_on_timeout = var.action_on_timeout
      # min
      # wait_time_in_minutes = 5
      wait_time_in_minutes = var.wait_time_in_minutes
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  depends_on = [
                aws_ecs_service.this
              ]

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "${var.ecs_cluster_name}"
    service_name = "${var.service_name}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          var.https_yn == true ? aws_lb_listener.blue_green_https[0].arn : aws_lb_listener.blue_green[0].arn
          ]
      }

      target_group {
        name = aws_lb_target_group.blue_target_group.name
      }

      target_group {
        name = aws_lb_target_group.green_target_group.name
      }

      test_traffic_route {
        listener_arns = [          
          aws_lb_listener.test_blue_green.arn
          ]
      }
    }
  }
}

#################################################################################
## codedeploy_role
#################################################################################
# resource "aws_iam_role" "codedeploy_role" {
#   name = "${var.env}-${var.project_name}-${var.service_name}-codedeploy-role"

#   assume_role_policy = jsonencode(
#                                     {
#                                       "Version": "2012-10-17",
#                                       "Statement": [
#                                         {
#                                           "Sid": "",
#                                           "Effect": "Allow",
#                                           "Principal": {
#                                             "Service": "codedeploy.amazonaws.com"
#                                           },
#                                           "Action": "sts:AssumeRole"
#                                         }
#                                       ]
#                                     }
#   )

#   # managed_policy_arns = [
#   #                         "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"                          
#   #                       ]

# }
           
# # resource "aws_iam_policy_attachment" "codedeploy_role" {
# resource "aws_iam_role_policy_attachment" "codedeploy_role" {
#   # name       = "${var.env}-${var.project_name}-${var.service_name}-codedeploy-attach"
#   role      = aws_iam_role.codedeploy_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
# }

# resource "aws_iam_role_policy" "codedeploy_role" {  
#   name = "${var.env}-${var.project_name}-${var.service_name}-codedeploy-policy"  
#   role       = aws_iam_role.codedeploy_role.name

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:*"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::fire-cicd-source/*",
#                 "arn:aws:s3:::fire-cicd-source"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kms:DescribeKey",
#                 "kms:GenerateDataKey*",
#                 "kms:Encrypt",
#                 "kms:ReEncrypt*",
#                 "kms:Decrypt"
#             ],
#             "Resource": [
#                 "arn:aws:kms:ap-northeast-2:201601922319:key/b41db288-fe93-4d54-bcbe-2e42e513e57d",
#                 "arn:aws:kms:ap-northeast-2:201601922319:key/c614061b-76d2-4274-93a7-30e18abc0050"
#             ]
#         }
#     ]
# }
# EOF
# }
# The IAM role arn:aws:iam::259287207567:role/codedeploy_role does not give you permission to perform operations in the following AWS service: AmazonElasticLoadBalancingV2. Contact your AWS administrator if you need help. If you are an AWS administrator, you can grant permissions to your users or groups by creating IAM policies.
# -> AWScodedeploy_roleForECS

#################################################################################
## cross_account_role
#################################################################################
# resource "aws_iam_role" "cross_account_role" {
#   name = "${var.app_name}-cross-account-by-cicd-role"  

#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::${var.cicd_account}:root"
#             },
#             "Action": "sts:AssumeRole",
#             "Condition": {}
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "cross_account_role" {  
#   name = "${var.app_name}-cross-account-by-cicd-policy"  
#   role = aws_iam_role.cross_account_role.id

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "codedeploy:CreateDeployment",
#                 "codedeploy:GetDeployment",
#                 "codedeploy:GetDeploymentConfig",
#                 "codedeploy:GetApplicationRevision",
#                 "codedeploy:RegisterApplicationRevision",
#                 "codedeploy:GetApplication"                
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:GetObject*",
#                 "s3:PutObject",
#                 "s3:PutObjectAcl",
#                 "codecommit:ListBranches",
#                 "codecommit:ListRepositories"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::fire-cicd-source/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kms:DescribeKey",
#                 "kms:GenerateDataKey*",
#                 "kms:Encrypt",
#                 "kms:ReEncrypt*",
#                 "kms:Decrypt"
#             ],
#             "Resource": [
#                 "arn:aws:kms:ap-northeast-2:201601922319:key/b41db288-fe93-4d54-bcbe-2e42e513e57d",
#                 "arn:aws:kms:ap-northeast-2:201601922319:key/c614061b-76d2-4274-93a7-30e18abc0050"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ecs:RegisterTaskDefinition"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "iam:PassRole"
#             ],
#             "Resource": "*"
#         }
        
#     ]
# }
# EOF
# }


# User: arn:aws:sts::259287207567:assumed-role/cross_account_role/1647222973891 is not authorized to perform: codedeploy:GetApplication on resource: arn:aws:codedeploy:ap-northeast-2:259287207567:application:dockerTest because no identity-based policy allows the codedeploy:GetApplication action
# --> codedeploy:GetApplication

# You are missing permissions to access input artifact: BuildArtifact.
# --> kms

# User: arn:aws:sts::259287207567:assumed-role/cross_account_role/1647223549862 is not authorized to perform: ecs:RegisterTaskDefinition on resource: * because no identity-based policy allows the ecs:RegisterTaskDefinition action
# --> ecs:RegisterTaskDefinition
# --> "iam:PassRole"