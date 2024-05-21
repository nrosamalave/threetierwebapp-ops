# VPC definition
resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr_block
}

# Subnet definition
resource "aws_subnet" "this" {
  for_each = { 
    for az, subnet_info in local.subnets : 
    "${az}-${subnet_info.each.value.key}" => {
      for subnet_name, cidr_block in subnet_info : 
        subnet_name => {
          cidr_block        = cidr_block
          availability_zone = az
        }
    } 
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = "${each.key}"
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
  for_each = toset(local.route_tables)
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
    for az, subnet_info in local.subnets : 
    "${az}-${subnet_name}" => {
      for subnet_name, _ in subnet_info : 
        subnet_name => {
          subnet_id      = aws_subnet.this["${az}-${subnet_name}"].id
          route_table_id = aws_route_table.this[subnet_name].id
        }
    }
  }
  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}