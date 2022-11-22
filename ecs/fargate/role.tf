############################################################################
## ecs_execution_role
############################################################################
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.env}-${var.project_name}-${var.service_name}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_role.json

  # managed_policy_arns = [
  #                         "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  #                         aws_iam_policy.parameter_policy.arn
  #                       ]  
  managed_policy_arns = var.execution_managed_policy_arns
}



# resource "aws_iam_role_policy_attachment" "ecs_execution_role" {
#   role       = aws_iam_role.ecs_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

############################################################################
## ecs_task_role
############################################################################
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.env}-${var.project_name}-${var.service_name}-ecs-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_execution_role.json                        

  # managed_policy_arns = [
  #                         aws_iam_policy.rekognition_policy.arn
  #                       ]  
  managed_policy_arns = var.task_managed_policy_arns
}


############################################################################
## codedeploy
############################################################################
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.env}-${var.project_name}-${var.service_name}-codedeploy-role"

  assume_role_policy = data.aws_iam_policy_document.codedeploy_role.json  

  managed_policy_arns = [
                          "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS",
                          aws_iam_policy.codedeploy_policy.arn
                        ]
}