
# https://www.kisphp.com/terraform/terraform-find-ubuntu-and-amazon-linux-2-amis
data "aws_ami" "this" {

  count = var.bastion_instance_yn == true ? 1 : 0

  most_recent = true
  owners      = var.bastion_ami_owners

  filter {
    name   = "name"
    values = [var.bastion_ami_name]
  }
}



resource "aws_instance" "bastion_ec2" {

  count = var.bastion_instance_yn == true ? 1 : 0

  ami                         = data.aws_ami.this[0].image_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_security_group[0].id]
  iam_instance_profile        = aws_iam_instance_profile.bastion_instance_role[0].name
  associate_public_ip_address = true
  source_dest_check           = false

  key_name = var.key_name

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  tags = merge(
    {
      Name = "${var.env}-${var.project_name}-bastion-01"
    },
    var.bastion_ec2_auto_on_off == true ? { auto_schedule_on_off = true } : {}
  )

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}

resource "aws_eip" "bastion_ec2" {

  count = var.bastion_instance_yn == true ? 1 : 0

  instance = aws_instance.bastion_ec2[0].id
  vpc      = true
  
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-bastion-01"
    }
  )
}