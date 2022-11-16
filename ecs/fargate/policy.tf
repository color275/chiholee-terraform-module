data "aws_iam_policy_document" "ecs_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

##################################################################
## codedeploy
##################################################################
data "aws_iam_policy_document" "codedeploy_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "codedeploy_policy" {
  name = "${var.service_name}-${var.container_name}-codedeploy-policy"
  policy = data.aws_iam_policy_document.codedeploy_policy.json
}


data "aws_iam_policy_document" "codedeploy_policy" {
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::fire-sandbox-cicd-source/*",
      "arn:aws:s3:::fire-sandbox-cicd-source",
      "arn:aws:s3:::fire-cicd-source/*",
      "arn:aws:s3:::fire-cicd-source",
    ]
  }
  statement {
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
    ]
    resources = [
      # "arn:aws:kms:ap-northeast-2:201601922319:key/b41db288-fe93-4d54-bcbe-2e42e513e57d",
      # "arn:aws:kms:ap-northeast-2:201601922319:key/c614061b-76d2-4274-93a7-30e18abc0050",
      "arn:aws:kms:ap-northeast-2:201601922319:key/33670891-05b2-4d7e-bd5e-9836f7a4184b",
      "arn:aws:kms:ap-northeast-2:513087882511:key/5adb5093-63a5-454d-ae7a-599663564320",
    ]
  }
}

##################################################################
## parameter store
##################################################################
# resource "aws_iam_policy" "parameter_policy" {
#   name = "${var.service_name}-${var.container_name}-parameter-policy"  
#   policy = data.aws_iam_policy_document.parameter_policy.json
# }

# data "aws_iam_policy_document" "parameter_policy" {
#   statement {
#     actions = [
#       "ssm:*",
#       "secretsmanager:GetSecretValue",
#       "kms:Decrypt",
#     ]

#     resources = [
#       "arn:aws:ssm:ap-northeast-2:${var.account_id}:parameter/*",
#       "arn:aws:secretsmanager:ap-northeast-2:${var.account_id}:secret:*",
#       "arn:aws:kms:ap-northeast-2:${var.account_id}:key/*",
#     ]
#   }
#   statement {
#     actions = [
#       "s3:*",
#     ]
#     resources = [
#       "*",
#     ]
#   }
# }

##################################################################
## rekognition policy
##################################################################
# resource "aws_iam_policy" "rekognition_policy" {
#   name = "${var.service_name}-${var.container_name}-rekognition-policy"  
#   policy = data.aws_iam_policy_document.rekognition_policy.json
# }

# data "aws_iam_policy_document" "rekognition_policy" {
#   statement {
#     actions = [
#       "rekognition:*"
#     ]

#     resources = [
#       "*"
#     ]
#   } 
# }