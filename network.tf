# VPC
resource "aws_vpc" "my-project-vpc" {
  for_each         = local.vpc 
  cidr_block       = each.value
  instance_tenancy = "default"
}

# Subnets
resource "aws_subnet" "my-public-web-subnet" {
  for_each          = local.subnet
  vpc_id            = aws_vpc.my-project-vpc[each.key].id
  cidr_block        = each.cidr.value
  availability_zone = each.availability_zones.value
}
