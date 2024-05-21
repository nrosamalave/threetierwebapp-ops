# VPC
resource "aws_vpc" "my-project-vpc" {
  for_each         = local.vpc 
  cidr_block       = each.value
  instance_tenancy = "default"
}

# Subnets
resource "aws_subnet" "my-public-web-subnet" {
  for_each          = local.subnet.cidr
  vpc_id            = aws_vpc.my-project-vpc[each.key].id
  cidr_block        = each.value
  for_each          = local.subnet.availability_zones
  availability_zone = each.value
}
