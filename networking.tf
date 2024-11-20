resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route = []

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/24"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "ass_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route = []

  tags = {
    Name = "private_rt"
  }
}

resource "aws_route" "route1" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/24"
  nat_gateway_id         = aws_nat_gateway.gw_NAT.id
}

resource "aws_route_table_association" "ass_private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_nat_gateway" "gw_NAT" {
  allocation_id = aws_eip.bar.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "gw_NAT"
  }
}

resource "aws_eip" "bar" {
  domain = "vpc"
}





