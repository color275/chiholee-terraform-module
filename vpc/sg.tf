
###################################################################################
## codebuild sg
###################################################################################
resource "aws_security_group" "codebuild_security_group" {
  count = var.codeseries_endpoint_yn == true ? 1 : 0

  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.env}-${var.project_name}-codebuild-sg"

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-codebuild-sg"
    }
  )

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true

  }
}

###################################################################################
## endpoint group sg
###################################################################################

resource "aws_security_group" "endpoint_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.env}-${var.project_name}-endpoint-sg"

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-endpoint-sg"
    }
  )

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true

  }
}

resource "aws_security_group_rule" "endpoint_security_group" {
  count             = length(var.endpoint_ingress_rules)
  type              = "ingress"
  from_port         = var.endpoint_ingress_rules[count.index][0]
  to_port           = var.endpoint_ingress_rules[count.index][1]
  protocol          = var.endpoint_ingress_rules[count.index][2]
  cidr_blocks       = var.endpoint_ingress_rules[count.index][3]
  description       = var.endpoint_ingress_rules[count.index][4]
  security_group_id = aws_security_group.endpoint_security_group.id
}


###################################################################################
## bastion sg
###################################################################################
resource "aws_security_group" "bastion_security_group" {
  count = var.bastion_instance_yn == true ? 1 : 0

  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.env}-${var.project_name}-bastion-sg"  

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-bastion-sg"
    }
  )

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true

  }
}

resource "aws_security_group_rule" "bastion_security_group" {
  count             = var.bastion_instance_yn == true && length(var.bastion_ingress_rules) > 0 ? length(var.bastion_ingress_rules) : 0
  type              = "ingress"
  from_port         = var.bastion_ingress_rules[count.index][0]
  to_port           = var.bastion_ingress_rules[count.index][1]
  protocol          = var.bastion_ingress_rules[count.index][2]
  cidr_blocks       = var.bastion_ingress_rules[count.index][3]
  description       = var.bastion_ingress_rules[count.index][4]
  security_group_id = aws_security_group.bastion_security_group[0].id
}


###################################################################################
## frontend group sg
###################################################################################

resource "aws_security_group" "frontend_subnet_sg" {
  count       = var.frontend_subnet_sg_yn == true ? 1 : 0
  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.project_name}-frontend-subnet-sg"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-frontend-subnet-sg"
    }
  )

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true

  }
}



resource "aws_security_group_rule" "frontend_subnet_bastion_sg" {
  count                    = var.frontend_bastion_yn ? 1 : 0
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_security_group[0].id
  description              = "nat instance"
  security_group_id        = aws_security_group.frontend_subnet_sg[0].id
}


###################################################################################
## backendend group sg
###################################################################################

resource "aws_security_group" "backend_subnet_sg" {
  count       = var.backend_subnet_sg_yn == true ? 1 : 0
  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.project_name}-backend-subnet-sg"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-backend-subnet-sg"
    }
  )

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true

  }
}


resource "aws_security_group_rule" "backend_subnet_sg" {
  count       = var.backend_subnet_sg_yn && var.frontend_subnet_sg_yn ? 1 : 0

  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.frontend_subnet_sg[0].id
  description              = "frontend subnet sg"
  security_group_id        = aws_security_group.backend_subnet_sg[0].id
}

resource "aws_security_group_rule" "backend_subnet_bastion_sg" {
  count                    = var.backend_bastion_yn ? 1 : 0
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_security_group[0].id
  description              = "nat instance"
  security_group_id        = aws_security_group.backend_subnet_sg[0].id
}



###################################################################################
## db group sg
###################################################################################

resource "aws_security_group" "db_subnet_sg" {
  count       = var.db_subnet_sg_yn == true ? 1 : 0

  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.project_name}-db-subnet-sg"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-subnet-sg"
    }
  )

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true

  }
}

resource "aws_security_group_rule" "db_subnet_sg" {
  count       = var.db_subnet_sg_yn && var.backend_subnet_sg_yn ? 1 : 0

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_subnet_sg[0].id
  description              = "backend subnet sg"
  security_group_id        = aws_security_group.db_subnet_sg[0].id
}


resource "aws_security_group_rule" "db_subnet_bastion_sg" {
  count                    = var.db_bastion_yn ? 1 : 0

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_security_group[0].id
  description              = "nat instance"
  security_group_id        = aws_security_group.db_subnet_sg[0].id
}