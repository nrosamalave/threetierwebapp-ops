

# Subnets
#resource "aws_subnet" "my-public-web-subnet-1" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.public-web.one
#  availability_zone = each.value.availability_zones.useasta
#}

#resource "aws_subnet" "my-public-web-subnet-2" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.public-web.two
#  availability_zone = each.value.availability_zones.useastb
#}

#resource "aws_subnet" "my-public-web-subnet-3" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.public-web.three
#  availability_zone = each.value.availability_zones.useastc
#}

#resource "aws_subnet" "my-private-app-subnet-1" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.private-app.one
#  availability_zone = each.value.availability_zones.useasta
#}

#resource "aws_subnet" "my-private-app-subnet-2" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.private-app.two
#  availability_zone = each.value.availability_zones.useastb
#}

#resource "aws_subnet" "my-private-app-subnet-3" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.private-app.three
#  availability_zone = each.value.availability_zones.useastc
#}

#resource "aws_subnet" "my-private-db-subnet-1" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.private-db.one
#  availability_zone = each.value.availability_zones.useasta
#}

#resource "aws_subnet" "my-private-db-subnet-2" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.private-db.two
#  availability_zone = each.value.availability_zones.useastb
#}

#resource "aws_subnet" "my-private-db-subnet-3" {
#  for_each          = local.subnet
#  vpc_id            = aws_vpc.my-project-vpc.id
#  cidr_block        = each.value.cidr.private-db.three
#  availability_zone = each.value.availability_zones.useastc
#}
