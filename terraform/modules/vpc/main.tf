resource "aws_vpc" "n8n-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true     # required for VPC endpoints to work
    enable_dns_support = true       # required for VPC endpoints to work

    tags = {
      Name = "${local.name}-vpc"
    }
}

resource "aws_subnet" "subnets" {
    vpc_id = aws_vpc.n8n-vpc.id
    for_each = local.subnets
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = each.value.public


    tags = {
      Name = "${local.name}-${each.key}"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.n8n-vpc.id

  tags = {
    Name = "${local.name}-igw"
  }
}

resource "aws_nat_gateway" "n8n-nat" {
  for_each = { for k, v in local.subnets : k => v if v.public }
  subnet_id = aws_subnet.subnets[each.key].id
  allocation_id = aws_eip.nat.id

  tags = {
    Name = "${local.name}-nat"
}

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw.id]
}

resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw.id]
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.n8n-vpc.id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = { for k, v in local.subnets : k => v if v.public } # Filter local.subnets down to only public subnets and loop over the result
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.subnets[each.key].id
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.n8n-vpc.id

  route {
    cidr_block = var.public_cidr
    nat_gateway_id = aws_nat_gateway.n8n-nat.id
  }

  tags = {
    Name = "${local.name}-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  for_each = { for k, v in local.subnets : k => v if !v.public }
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.subnets[each.key].id # loops through each key in the locals block to associate each subnet, the for_each block already identified which subnets to use
}

resource "aws_security_group" "vpc-sg" {
  name        = "n8n-vpc-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.n8n-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.vpc-sg.id
  cidr_ipv4         = var.public_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.vpc-sg.id
  cidr_ipv4         = var.public_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.vpc-sg.id
  cidr_ipv4         = var.public_cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}