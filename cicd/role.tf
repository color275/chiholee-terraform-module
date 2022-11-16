resource "aws_iam_role" "codebuild_role" {
  name = "${var.container_name}-${var.service_name}-codebuild-role"

  assume_role_policy = data.aws_iam_policy_document.codebuild_role.json
  
  managed_policy_arns = [
                          aws_iam_policy.codebuild_policy.arn
                        ]
} 



resource "aws_iam_role" "codepipeline_role" {
  name = "${var.container_name}-${var.service_name}-codepipeline-role"  

  assume_role_policy = data.aws_iam_policy_document.codepipeline_role.json

  managed_policy_arns = [
                          aws_iam_policy.codepipeline_policy.arn,
                          aws_iam_policy.assume_policy.arn
                        ]
}