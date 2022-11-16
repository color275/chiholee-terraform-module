output "sg_id" {
  value = aws_security_group.this.id
}

output "lb_dns_name" {
  value = aws_lb.this.dns_name
}