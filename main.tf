#VPC 
resource "aws_vpc" "my-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
   Name = "my-vpc"
 }
}

#Subnets
#resource "aws_subnet" "public_web_subnets" {
# count             = length(var.public_subnet_cidrs_web)
# vpc_id            = aws_vpc.my-vpc.id
# cidr_block        = element(var.public_subnet_cidrs_web, count.index)
# availability_zone = element(var.azs, count.index)
# 
# tags = {
#   Name = "my-public-web-subnet-${count.index + 1}"
# }
#}

resource "aws_subnet" "public_web_subnets" {
  for_each          = { for idx, subnet in var.public_subnet_cidrs_web : idx => subnet }
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "public-subnet-${each.key}"
  }
}
 
resource "aws_subnet" "private_app_subnets" {
 count             = length(var.private_subnet_cidrs_app)
 vpc_id            = aws_vpc.my-vpc.id
 cidr_block        = element(var.private_subnet_cidrs_app, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "my-private-app-subnet-${count.index + 1}"
 }
}

resource "aws_subnet" "private_db_subnets" {
 count             = length(var.private_subnet_cidrs_db)
 vpc_id            = aws_vpc.my-vpc.id
 cidr_block        = element(var.private_subnet_cidrs_db, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "my-private-db-subnet-${count.index + 1}"
 }
}

# Route Tables 
resource "aws_route_table" "my-public-web-route-table" {    //public-web rt
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-public-web-route-table"
  }
}

resource "aws_route_table" "my-private-app-route-table" {   //private-app rt
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-private-app-route-table"
  }
}

resource "aws_route_table" "my-private-db-route-table" {    //private-db rt
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-private-db-route-table"
  }
}

# Route Table Associations 

resource "aws_route_table_association" "public-web-rt-association" {
  count          = length(var.public_subnet_cidrs_web)
  subnet_id      = element(aws_subnet.public_web_subnets[*].id, count.index)
  route_table_id = aws_route_table.my-public-web-route-table.id
}

resource "aws_route_table_association" "private-app-rt-association" {
  count          = length(var.private_subnet_cidrs_app)
  subnet_id      = element(aws_subnet.private_app_subnets[*].id, count.index)
  route_table_id = aws_route_table.my-private-app-route-table.id
}

resource "aws_route_table_association" "private-db-rt-association" {
  count          = length(var.private_subnet_cidrs_db)
  subnet_id      = element(aws_subnet.private_db_subnets[*].id, count.index)
  route_table_id = aws_route_table.my-private-db-route-table.id
}