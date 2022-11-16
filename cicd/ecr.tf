#####################################################
## ecr_repository
#####################################################

resource "aws_ecr_repository" "ecr_repository" {
  name = lower("${var.container_name}/${var.service_name}")
  
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.ecr_repository.name
  policy     = data.aws_iam_policy_document.push_and_pull.json
}


data "aws_iam_policy_document" "push_and_pull" {  
  statement {    
    effect = "Allow"

    principals {
      identifiers = [
                      var.dev_account_id,
                      var.test_account_id,
                    ]
      type        = "AWS"
    }
    
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"      
    ]
  }
}


resource "aws_ecr_lifecycle_policy" "ecr_repository" {
  repository = aws_ecr_repository.ecr_repository.name

  policy = jsonencode(    
                        {
                          "rules": [
                            {
                              "rulePriority": 1,
                              "description": "Keep image deployed with tag latest",
                              "selection": {
                                "tagStatus": "tagged",
                                "tagPrefixList": ["latest"],
                                "countType": "imageCountMoreThan",
                                "countNumber": 1
                              },
                              "action": {
                                "type": "expire"
                              }
                            },
                            {
                              "rulePriority": 2,
                              "description": "Keep last 2 any images",
                              "selection": {
                                "tagStatus": "any",
                                "countType": "imageCountMoreThan",
                                "countNumber": 2
                              },
                              "action": {
                                "type": "expire"
                              }
                            }
                          ]
                        }
                      )

}
