resource "aws_vpc" "chainlink_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "chainlink_vpc"
  }
}

resource "aws_subnet" "db_subnet1" {
  vpc_id            = aws_vpc.chainlink_vpc.id
  cidr_block        = "192.168.8.0/24"
  availability_zone = var.availability_zone_a

  tags = {
    Name = "chainlink_db_subnet"
  }
}

resource "aws_subnet" "db_subnet2" {
  vpc_id            = aws_vpc.chainlink_vpc.id
  cidr_block        = "192.168.9.0/24"
  availability_zone = var.availability_zone_b

  tags = {
    Name = "chainlink_db_subnet"
  }
}

// chainlink nodes are allocated in different availability zones
// to improve availability
resource "aws_subnet" "ec2_subnet_1" {
  vpc_id            = aws_vpc.chainlink_vpc.id
  cidr_block        = "192.168.11.0/24"
  availability_zone = var.availability_zone_a

  tags = {
    Name = "chainlink_ec2_subnet_1"
  }
}

resource "aws_subnet" "ec2_subnet_2" {
  vpc_id            = aws_vpc.chainlink_vpc.id
  cidr_block        = "192.168.12.0/24"
  availability_zone = var.availability_zone_b

  tags = {
    Name = "chainlink_ec2_subnet_2"
  }
}

resource "aws_subnet" "ec2_subnet_3" {
  vpc_id            = aws_vpc.chainlink_vpc.id
  cidr_block        = "192.168.13.0/24"
  availability_zone = var.availability_zone_c

  tags = {
    Name = "chainlink_ec2_subnet_3"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.chainlink_vpc.id

  tags = {
    Name = "chainlink_gateway"
  }
}

resource "aws_route_table" "chainlink" {
  vpc_id = aws_vpc.chainlink_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "chainlink_route"
  }
}

resource "aws_route_table_association" "subnet_1" {
  subnet_id      = aws_subnet.ec2_subnet_1.id
  route_table_id = aws_route_table.chainlink.id
}

resource "aws_route_table_association" "subnet_2" {
  subnet_id      = aws_subnet.ec2_subnet_2.id
  route_table_id = aws_route_table.chainlink.id
}

resource "aws_route_table_association" "subnet_3" {
  subnet_id      = aws_subnet.ec2_subnet_3.id
  route_table_id = aws_route_table.chainlink.id
}

resource "aws_route_table_association" "subnet_db1" {
  subnet_id      = aws_subnet.db_subnet1.id
  route_table_id = aws_route_table.chainlink.id
}

resource "aws_route_table_association" "subnet_db2" {
  subnet_id      = aws_subnet.db_subnet2.id
  route_table_id = aws_route_table.chainlink.id
}

