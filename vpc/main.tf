

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.project_name}-${var.project_env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.project_name}-${var.project_env}-igw"

  }
}

locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.public_subnet_count
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_newbits, count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.selected_azs[count.index % length(local.selected_azs)]
  tags = {
    "Name" = "${var.project_name}-${var.project_env}-publicsubnet-${count.index + 1}"
  }
}


resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count = var.enable_private_subnet == true ? var.private_subnet_count : 0
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_newbits, "${count.index + 2}")
  map_public_ip_on_launch = false
  availability_zone       = local.selected_azs[count.index % length(local.selected_azs)]
  tags = {
    "Name" = "${var.project_name}-${var.project_env}-privatesubnet-${count.index + 1}"
  }
}

resource "aws_eip" "vpc_eip" {
  count  = var.enable_nat_gw == true ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-${var.project_env}-nat"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.vpc_eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.project_name}-${var.project_env}"
  }


  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-public-route-table"
  }
}

resource "aws_route_table_association" "public-association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}



resource "aws_route_table" "private_route_table" {
  count = var.enable_private_subnet == true ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-private-route-table"
  }
}

resource "aws_route_table_association" "private-association" {
  count = var.enable_private_subnet == true ? var.private_subnet_count : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}
