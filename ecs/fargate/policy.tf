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
  name = "${var.env}-${var.project_name}-${var.service_name}-codedeploy-policy"
  policy = data.aws_iam_policy_document.codedeploy_policy.json
}


data "aws_iam_policy_document" "codedeploy_policy" {
  statement {
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::${var.source_bucket_name}"
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
      var.kms_arn
    ]
  }
}

##################################################################
## parameter store
##################################################################
# resource "aws_iam_policy" "parameter_policy" {
#   name = "${var.env}-${var.project_name}-${var.service_name}-parameter-policy"  
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
#   name = "${var.env}-${var.project_name}-${var.service_name}-rekognition-policy"  
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