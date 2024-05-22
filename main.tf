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
  for_each       = aws_subnet.public-web
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = each.value.id

  tags = {
    Name = "my-nat-gw"
  }

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

resource "aws_route" "public_web_route" {                    // route for "web" rt
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my-igw.id
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "private-app-rt"
  }
}

resource "aws_route" "private_app_route" {                    // route for "app" rt
  route_table_id         = aws_route_table.app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.my-nat-gw.id
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "private-db-rt"
  }
}

resource "aws_route" "private_db_route" {                    // route for "db" rt
  route_table_id         = aws_route_table.db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.my-nat-gw.id
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