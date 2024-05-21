module "aws_vpc" {
    source = "./modules/aws/vpcs"
    cidr_block = local.vpc_cidr
}