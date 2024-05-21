resource "aws_vpc" "my-vpc" {
  for_each         = var.cidr_block
  cidr_block       = each.value
  instance_tenancy = "default"

}