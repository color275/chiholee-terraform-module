resource "aws_codecommit_repository" "this" {
  repository_name = "${var.container_name}-${var.service_name}"
  description     = var.codecommit_repository_description

  lifecycle {
    # true : 삭제 방지
    prevent_destroy = true
  }

  tags = local.tags_merge
}

output "clone_url" {
  value = <<EOF
aws configure
git init
git remote add origin ${aws_codecommit_repository.this.clone_url_http}
git remote -v
git branch
git checkout -b main
git fetch
EOF
}


