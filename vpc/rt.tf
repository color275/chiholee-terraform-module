###################################################
## Route Table
###################################################
# Public
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public_route_table" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route" "public_r1" {
  count = var.internet_gateway == true ? 1 : 0
  route_table_id              = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway[0].id
}

resource "aws_route" "public_r2" {
  for_each = { for v in var.transit_gateway_cidr : v => v }
  route_table_id              = aws_route_table.public_route_table.id
  destination_cidr_block         = each.key
  transit_gateway_id = var.transit_gateway_id
}

# frontend
resource "aws_route_table" "frontend_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-frontend-rt"
    }
  )

}

resource "aws_route_table_association" "frontend_route_table" {
  count          = length(aws_subnet.frontend_subnet)
  subnet_id      = aws_subnet.frontend_subnet[count.index].id
  route_table_id = aws_route_table.frontend_route_table.id
}

# resource "aws_route" "frontend_r1" {
#   count = var.bastion_instance_yn && var.frontend_internet_yn ? 1 : 0
#   route_table_id              = aws_route_table.frontend_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   instance_id = aws_instance.bastion_ec2[0].id
# }

resource "aws_route" "frontend_r1" {
  count = var.natgateway_yn == true && var.frontend_internet_yn ? 1 : 0
  route_table_id              = aws_route_table.frontend_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
}

resource "aws_route" "frontend_r2" {
  for_each = { for v in var.transit_gateway_cidr : v => v }
  route_table_id              = aws_route_table.frontend_route_table.id
  destination_cidr_block         = each.key
  transit_gateway_id = var.transit_gateway_id
}

# backend
resource "aws_route_table" "backend_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-backend-rt"
    }
  )

  
}

resource "aws_route_table_association" "backend_route_table" {
  count          = length(aws_subnet.backend_subnet)
  subnet_id      = aws_subnet.backend_subnet[count.index].id
  route_table_id = aws_route_table.backend_route_table.id
}

# resource "aws_route" "backend_r1" {
#   count = var.bastion_instance_yn && var.backend_internet_yn ? 1 : 0
#   route_table_id              = aws_route_table.backend_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   instance_id = aws_instance.bastion_ec2[0].id
# }

resource "aws_route" "backend_r1" {
  count = var.natgateway_yn == true && var.backend_internet_yn ? 1 : 0
  route_table_id              = aws_route_table.backend_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
}

resource "aws_route" "backend_r2" {
  for_each = { for v in var.transit_gateway_cidr : v => v }
  route_table_id              = aws_route_table.backend_route_table.id
  destination_cidr_block         = each.key
  transit_gateway_id = var.transit_gateway_id
}

# db
resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-${var.project_name}-db-rt"
    }
  )

  # dynamic "route" {
  #   for_each = { for v in var.transit_gateway_cidr : v => v }
  #   content {
  #     cidr_block         = route.key
  #     transit_gateway_id = var.transit_gateway_id
  #   }
  # }
}

resource "aws_route_table_association" "db_route_table" {
  count          = length(aws_subnet.db_subnet)
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_route_table.id
}

resource "aws_route" "db_r1" {
  for_each = { for v in var.transit_gateway_cidr : v => v }
  route_table_id              = aws_route_table.db_route_table.id
  destination_cidr_block         = each.key
  transit_gateway_id = var.transit_gateway_id
}