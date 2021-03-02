resource "aws_security_group" "chainlink_node_sg" {
  name        = "chainlink_node_sg"
  description = "Security group for chainlink node instance"
  vpc_id      = aws_vpc.chainlink_vpc.id

  ingress {
    description = "http from VPC"
    from_port   = 6688
    to_port     = 6688
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  ingress {
    description = "node exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env  = "dev"
    Name = "chainlink_node_sg"
  }
}

resource "aws_security_group" "chainlink_monitor_sg" {
  name        = "chainlink_monitor_sg"
  description = "Security group for chainlink monitor instance"
  vpc_id      = aws_vpc.chainlink_vpc.id

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  ingress {
    description = "prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  ingress {
    description = "garfana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  ingress {
    description = "alertmanager"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env  = "dev"
    Name = "chainlink_monitor_sg"
  }
}

resource "aws_security_group" "chainlink_db_sg" {
  name        = "chainlink_db_sg"
  description = "Security group for chainlink db instance"
  vpc_id      = aws_vpc.chainlink_vpc.id

  ingress {
    description = "db connection from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  tags = {
    Env  = "dev"
    Name = "chainlink_db_sg"
  }
}

resource "aws_security_group" "chainlink_vpn_sg" {
  name        = "chainlink_vpn_sg"
  description = "Security group for vpn instance"
  vpc_id      = aws_vpc.chainlink_vpc.id

  ingress {
    from_port   = var.wg_server_port
    to_port     = var.wg_server_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.chainlink_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env  = "dev"
    Name = "chainlink_vpn_sg"
  }
}