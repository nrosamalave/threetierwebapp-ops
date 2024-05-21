resource "aws_vpc" "main" {
  for_each         = var.cidr_block
  cidr_block       = each.value
  instance_tenancy = "default"

}