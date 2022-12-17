output "vpc_id" {
  value = aws_vpc.main.id
}

output "env" {
  value = var.env
}

output "project_name" {
  value = var.project_name
}


output "codebuild_security_group_id" {
  value = var.codeseries_endpoint_yn == true ? aws_security_group.codebuild_security_group[0].id : null
}

output "bastion_security_group_id" {
  value = var.bastion_instance_yn == true ? aws_security_group.bastion_security_group[0].id : null
}

output "bastion_public_ip" {
  value = aws_instance.bastion_ec2[0].public_ip
}

output "public_subnet_security_group_id" {
  value = aws_security_group.public_subnet_sg.id
}

output "frontend_subnet_security_group_id" {
  value = var.frontend_subnet_sg_yn == true ? aws_security_group.frontend_subnet_sg[0].id : null
}

output "backend_subnet_security_group_id" {
  value = var.backend_subnet_sg_yn == true ? aws_security_group.backend_subnet_sg[0].id : null
}

output "db_subnet_security_group_id" {
  value = var.db_subnet_sg_yn == true ? aws_security_group.db_subnet_sg[0].id : null
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnet.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "backend_subnet_ids" {
  value = aws_subnet.backend_subnet.*.id
}

output "frontend_subnet_ids" {
  value = aws_subnet.frontend_subnet.*.id
}

output "frontend_subnet_cidr" {
  value = var.frontend_cidr
}

output "backend_subnet_cidr" {
  value = var.backend_cidr
}

output "availability_zone" {
  value = [for v in var.availability_zone : v[1]]
}



