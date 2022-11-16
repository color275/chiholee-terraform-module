###########################################################################
## create endpoint for multi account deploy in env of dev, test, product
###########################################################################
resource "aws_vpc_endpoint" "ssm" {
  count = var.cicd_endpoint_yn == true || var.ssm_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.backend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true


  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ssm"
    }
  )
}

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.cicd_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.backend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true


  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ecr-api"
    }
  )
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.cicd_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.backend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ecr-dkr"
    }
  )
}

resource "aws_vpc_endpoint" "logs" {
  count = var.cicd_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.backend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-logs"
    }
  )
}

resource "aws_vpc_endpoint" "s3_gateway" {
  count = var.cicd_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  route_table_ids   = [aws_route_table.frontend_route_table.id, aws_route_table.backend_route_table.id]
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"


  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-s3-gateway"
    }
  )
}

###########################################################################
## create endpoint for connecting Nexus with codebuild
###########################################################################
resource "aws_vpc_endpoint" "codebuild" {
  count = var.codeseries_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.backend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.codebuild"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-codebuild"
    }
  )
}

resource "aws_vpc_endpoint" "codecommit" {
  count = var.codeseries_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.backend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.codecommit"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true


  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-codecommit"
    }
  )
}

resource "aws_vpc_endpoint" "git_codecommit" {
  count = var.codeseries_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.backend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.git-codecommit"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true


  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-git_codecommit"
    }
  )
}

###########################################################################
## create endpoint for using session manager
###########################################################################
resource "aws_vpc_endpoint" "ec2messages" {
  count = var.ssm_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.frontend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true


  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ec2messages"

    }
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count = var.ssm_endpoint_yn == true ? 1 : 0

  vpc_id            = aws_vpc.main.id
  subnet_ids        = aws_subnet.frontend_subnet.*.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint_security_group.id
  ]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ssmmessages"
    }
  )
}