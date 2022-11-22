data "aws_ami" "this" {
  most_recent      = true
  owners           = var.ami_owners

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}



resource "aws_instance" "this" {
  count = var.cnt
  ami           = data.aws_ami.this.image_id
  instance_type = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index)
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name  
  source_dest_check           = false
  key_name = var.key_name
  # user_data = file("templates/userdata.sh")    
  root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
  }

  tags = merge(
                {
                  Name = "${var.env}-${var.project_name}-${var.ec2_name}-${format("%02d", count.index + 1)}"
                }, 
                var.auto_on_off == true ? { auto_schedule_on_off = true } : {}
               )

  lifecycle {
    ignore_changes = [
                      user_data,
                      ami,
                      instance_type,
                      root_block_device
                     ]
  }
}


resource "aws_eip" "this" {

  count = var.cnt > 0 && var.eip_yn == true ? var.cnt : 0
  instance = aws_instance.this[count.index].id
  vpc      = true

  tags = {
    Name = "${var.project_name}-${var.ec2_name}-${format("%02d", count.index + 1)}"
  }
}