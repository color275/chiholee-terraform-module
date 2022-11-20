output "sg_id" {
  value = aws_security_group.this.id
}

output "public_ip" {
  value = ["${aws_instance.this.*.public_ip}"]
}

output "private_dns" {
  value = ["${aws_instance.this.*.private_dns}"]
}