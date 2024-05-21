# VPC definition
resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr_block
}

# Subnet definition
resource "aws_subnet" "this" {
  for_each = { for s in local.flattened_subnets : s.key => s }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    Name = each.value.key
  }
}

# Route Table definition
resource "aws_route_table" "this" {
  for_each = toset(local.route_tables)
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${each.key}-route_table"
  }
}

# Route definition
resource "aws_route" "this" {
  for_each = local.route_tables
  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Internet Gateway definition
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "this" {
  for_each = { 
    for s in local.flattened_subnets :
    "${s.az}-${s.name}" => {
      subnet_id = aws_subnet.this[s.key].id
      route_table_id = aws_route_table.this[substring(s.name, 7, length(s.name))].id
    }
  }
  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}