# Create VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "my-vpc"
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

resource "aws_subnet" "public-app" {
  for_each = { for idx, subnet in local.subnets.app : idx => subnet }

  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "app-subnet-${each.key}"
  }
}

resource "aws_subnet" "public-db" {
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

  route = []

  tags = {
    Name = "public-web-rt"
  }
}

# Route Table Association

resource "aws_route_table_association" "web-rt-asso" {
  for_each       = aws_subnet.public-web
  subnet_id      = each.value
  route_table_id = aws_route_table.web.id
}