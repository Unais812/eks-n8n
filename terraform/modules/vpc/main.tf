resource "aws_vpc" "n8n-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true     # required for VPC endpoints to work
    enable_dns_support = true       # required for VPC endpoints to work

    tags = {
      Name = "${local.name}-vpc"
    }
}

resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.n8n-vpc.id
    cidr_block = var.public-subnet-1-cidr
    availability_zone = var.az1

    tags = {
      Name = "public-subnet-1"
    }
}

resource "aws_subnet" "private-1" {
    vpc_id = aws_vpc.n8n-vpc.id
    cidr_block = var.private-subnet-1-cidr
    availability_zone = var.az1
    

    tags = {
      Name = "private-subnet-1"
    }
}

resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.n8n-vpc.id
    cidr_block = var.public-subnet-2-cidr
    availability_zone = var.az2

    tags = {
      Name = "public-subnet-2"
    }
}

resource "aws_subnet" "private-2" {
    vpc_id = aws_vpc.n8n-vpc.id
    cidr_block = var.private-subnet-2-cidr
    availability_zone = var.az2

    tags = {
      Name = "private-subnet-2"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.n8n-vpc.id

  tags = {
    Name = "${local.name}-igw"
  }
}

resource "aws_nat_gateway" "n8n-nat" {
  subnet_id = aws_subnet.public-1.id
  allocation_id = aws_eip.nat.id

  tags = {
    Name = "${local.name}-nat"
}

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat" {
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

resource "aws_route_table_association" "public-1" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.public-1.id
}

resource "aws_route_table_association" "public-2" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.public-2.id
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

resource "aws_route_table_association" "private-1" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.private-1.id
}

resource "aws_route_table_association" "private-2" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = aws_subnet.private-2.id
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