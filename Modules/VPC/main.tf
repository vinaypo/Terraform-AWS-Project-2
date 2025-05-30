data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.instance_tenancy
  tags = {
    Name = var.vpc_name
    Env  = var.env
  }
}

resource "aws_subnet" "Public_subnet" {
  count                   = var.env == "prod" ? 3 : 1
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = element(var.public_cidr_block, count.index)
  availability_zone       = element(data.aws_availability_zones.az.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.pubsub_name}-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_subnet" "Private_subnet" {
  count                   = var.env == "prod" ? 3 : 1
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = element(var.private_cidr_block, count.index)
  availability_zone       = element(data.aws_availability_zones.az.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prisub_name}-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.IGW_name
    Env  = var.env
  }
}

resource "aws_route_table" "Pub-RT" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name = var.PubRT_name
    Env  = var.env
  }
}

resource "aws_route_table_association" "Pub-RT-association" {
  count          = var.env == "prod" ? 3 : 1
  subnet_id      = aws_subnet.Public_subnet[count.index].id
  route_table_id = aws_route_table.Pub-RT.id
  depends_on     = [aws_internet_gateway.myIGW]
}

resource "aws_eip" "EIP" {
  count  = var.env == "prod" ? 2 : 1
  domain = "vpc"
  tags = {
    Name = "${var.EIP_name}-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "myNGW" {
  count             = var.env == "prod" ? 2 : 1
  allocation_id     = aws_eip.EIP[count.index].id
  connectivity_type = "public"
  subnet_id         = aws_subnet.Public_subnet[count.index].id # or element(aws_subnet.Public_subnet.*.id, count.index)
  tags = {
    Name = "${var.NGW_name}-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_route_table" "Pri-RT" {
  count  = var.env == "prod" ? 2 : 1
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = var.cidr_block
    nat_gateway_id = aws_nat_gateway.myNGW[count.index].id
  }
  tags = {
    Name = "${var.PriRT_name}-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_route_table_association" "Pri-RT-association" {
  count          = var.env == "prod" ? 3 : 1
  subnet_id      = aws_subnet.Private_subnet[count.index].id # or element(aws_subnet.Private_subnet.*.id, count.index)
  route_table_id = aws_route_table.Pri-RT[count.index % 2].id
  depends_on     = [aws_nat_gateway.myNGW]
}
