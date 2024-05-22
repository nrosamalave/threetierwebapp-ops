# Create VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public-web-subnets" {
  for_each   = local.subnets
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = toset(each.value.cidr)
  availability_zone = toset(each.value.az)

  tags = {
    Name = "public-web-subnets"
  }
}