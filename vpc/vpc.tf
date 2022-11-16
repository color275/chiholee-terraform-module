###################################################
# VPC
###################################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-vpc"
    }
  )
}

###################################################
# Internet Gateway
###################################################
resource "aws_internet_gateway" "internet_gateway" {

  count = var.internet_gateway == true ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-vpc"
    }
  )
}

###################################################
# Nat Gateway
###################################################
resource "aws_nat_gateway" "nat_gateway" {

  count = var.natgateway_yn == true ? 1 : 0

  allocation_id = aws_eip.nat_gateway[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-ng"
    }
  )

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_eip" "nat_gateway" {
  count = var.natgateway_yn == true ? 1 : 0
  vpc   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-ng"
    }
  )

}

###################################################
# Subnet Groups
###################################################
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = element(var.availability_zone, count.index)[1]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-public-${element(var.availability_zone, count.index)[0]}"
    }
  )
}

resource "aws_subnet" "frontend_subnet" {
  count                   = length(var.frontend_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.frontend_cidr[count.index]
  availability_zone       = element(var.availability_zone, count.index)[1]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-frontend-${element(var.availability_zone, count.index)[0]}"
    }
  )
}

resource "aws_subnet" "backend_subnet" {
  count = length(var.backend_cidr)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.backend_cidr[count.index]
  availability_zone       = element(var.availability_zone, count.index)[1]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-backend-${element(var.availability_zone, count.index)[0]}"
    }
  )
}

resource "aws_subnet" "db_subnet" {
  count = length(var.db_cidr)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_cidr[count.index]
  availability_zone       = element(var.availability_zone, count.index)[1]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-db-${element(var.availability_zone, count.index)[0]}"
    }
  )
}

