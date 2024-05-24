# Create VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "my-vpc"
  }
}

# Elastic IP

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

# NAT Gateway

resource "aws_nat_gateway" "my-nat-gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-web["0"].id // Assuming the first public subnet

  tags = {
    Name = "my-nat-gw"
  }

  depends_on = [aws_internet_gateway.my-igw]
}

# Create subnets
resource "aws_subnet" "public-web" {
  for_each = { for idx, subnet in local.subnets.web : idx => subnet }

  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "web-subnet-${each.key}"
  }
}

resource "aws_subnet" "private-app" {
  for_each = { for idx, subnet in local.subnets.app : idx => subnet }

  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "app-subnet-${each.key}"
  }
}

resource "aws_subnet" "private-db" {
  for_each = { for idx, subnet in local.subnets.db : idx => subnet }

  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "db-subnet-${each.key}"
  }
}

# Route Tables

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "public-web-rt"
  }
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "private-app-rt"
  }
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "private-db-rt"
  }
}

# Routes

resource "aws_route" "public_web_route" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my-igw.id
}

resource "aws_route" "private_app_route" {
  route_table_id         = aws_route_table.app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my-nat-gw.id
}

resource "aws_route" "private_db_route" {
  route_table_id         = aws_route_table.db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my-nat-gw.id
}

# Route Table Association

resource "aws_route_table_association" "web-rt-asso" {
  for_each       = aws_subnet.public-web
  subnet_id      = each.value.id
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "app-rt-asso" {
  for_each       = aws_subnet.private-app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "db-rt-asso" {
  for_each       = aws_subnet.private-db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.db.id
}

# Security Groups

resource "aws_security_group" "jump-server" {
  description = "Jump server sg"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (consider restricting this to specific IPs for security)
  }

  tags = {
    Name = "my-jump-server-sg"
  }
}

resource "aws_security_group_rule" "ssh-access-php-sg" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.jump-server.id
  source_security_group_id   = aws_security_group.php-sg.id
}

resource "aws_security_group" "php-sg" {
  description = "Allow SSH from the jump server"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jump-server.id]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = "0.0.0.0/0"
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = "0.0.0.0/0"
  }

  tags = {
    Name = "my-php-sg"
  }
}




# Key Pair

resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = var.aws_key
}

# EC2

resource "aws_instance" "instances" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  security_groups             = each.value.security_groups
  subnet_id                   = each.value.subnet_id
  tenancy                     = each.value.tenancy
  key_name                    = each.value.key_name
  associate_public_ip_address = each.value.associate_public_ip_address

  tags = {
    name = each.key
  }
  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }
}