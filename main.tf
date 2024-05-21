#VPC 
resource "aws_vpc" "my-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
   Name = "my-vpc"
 }
}

#Subnets
resource "aws_subnet" "public_web_subnets" {
 count      = length(var.public_subnet_cidrs_web)
 vpc_id     = aws_vpc.my-vpc.id
 cidr_block = element(var.public_subnet_cidrs_web, count.index)
 
 tags = {
   Name = "my-public-web-subnet-${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_app_subnets" {
 count      = length(var.private_subnet_cidrs_app)
 vpc_id     = aws_vpc.my-vpc.id
 cidr_block = element(var.private_subnet_cidrs_app, count.index)
 
 tags = {
   Name = "my-private-app-subnet-${count.index + 1}"
 }
}

resource "aws_subnet" "private_db_subnets" {
 count      = length(var.private_subnet_cidrs_db)
 vpc_id     = aws_vpc.my-vpc.id
 cidr_block = element(var.private_subnet_cidrs_db, count.index)
 
 tags = {
   Name = "my-private-db-subnet-${count.index + 1}"
 }
}