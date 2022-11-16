#####################################################
## ecr_repository
#####################################################

resource "aws_ecr_repository" "ecr_repository" {
  
  for_each = {for v in var.ecr_repository_name  : v => v}
  
  name = "${var.service_name}/${each.key}"
  
}

