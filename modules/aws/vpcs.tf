resource "aws_vpc" "my-project-vpc" {
  for_each         = var.cidr_block
  cidr_block       = each.value
  instance_tenancy = "default"
}