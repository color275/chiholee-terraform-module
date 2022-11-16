##################################################################
## codebuild
##################################################################
data "aws_iam_policy_document" "codebuild_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "${var.app_name}-${var.service_name}-codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

data "aws_iam_policy_document" "codebuild_policy" {
  ##################################################################################################################################
  ## VPC 연결 시 필요 권한 
  ## https://stackoverflow.com/questions/52843460/receive-not-authorized-to-perform-describesecuritygroups-when-creating-new-pro
  ##################################################################################################################################
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]
    resources = [
      "*",
    ]
  } 

  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission"      
    ]
    resources = [
      "arn:aws:ec2:*:*:network-interface/*"
    ]
    condition {
        test     = "StringLike"
        variable = "ec2:Subnet"

        values = [
          "arn:aws:ec2:*:*:subnet/*",
        ]
    }
    condition {
        test     = "StringLike"
        variable = "ec2:AuthorizedService"

        values = [
          "codebuild.amazonaws.com",
        ]
    }
  }   
  ################################################################################################################################## 



  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }  
  statement {
    actions = [
      "ssm:*",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
    ]

    resources = [
      "arn:aws:ssm:ap-northeast-2:${var.account_id}:parameter/*",
      "arn:aws:secretsmanager:ap-northeast-2:${var.account_id}:secret:*",
      "arn:aws:kms:ap-northeast-2:${var.account_id}:key/*",
    ]
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::${var.source_bucket_name}",
      "arn:aws:s3:::${var.source_bucket_name}/*",
    ]
  }
  statement {
    actions = [
      "codecommit:GitPull"
    ]
    resources = [
      "${aws_codecommit_repository.this.arn}",
    ]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = [
      "*",
    ]
    condition {
            test = "Bool"
            variable = "kms:GrantIsForAWSResource"
            values = [
                "true",
            ]
    }
  }  
}



##################################################################
## codepipeline
##################################################################




data "aws_iam_policy_document" "codepipeline_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}


resource "aws_iam_policy" "assume_policy" {  
  name = "${var.app_name}-${var.service_name}-assume-policy"
  policy = <<EOF
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": [                
                "arn:aws:iam::${var.dev_account_id}:role/${var.lambda_exec_role_name}",
                "arn:aws:iam::${var.test_account_id}:role/${var.lambda_exec_role_name}",
                "arn:aws:iam::${var.prod_account_id}:role/${var.lambda_exec_role_name}"
            ]
        }
    ],
    "Version": "2012-10-17"
}
EOF
}


resource "aws_iam_policy" "codepipeline_policy" {  
  name = "${var.app_name}-${var.service_name}-codepipeline-policy"
  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetRepository",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
            ],
            "Resource": "*"
        },
        {            
            "Effect": "Allow",         
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {         
            "Effect": "Allow",
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ],
    "Version": "2012-10-17"
}
EOF
}










