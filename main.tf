# Create VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "my-vpc"
  }
}

# Elastic IP

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

# NAT Gateway

resource "aws_nat_gateway" "my-nat-gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-web["0"].id // Assuming the first public subnet

  tags = {
    Name = "my-nat-gw"
  }

  depends_on = [aws_internet_gateway.my-igw]
}

# Create Subnets

resource "aws_subnet" "public-web" {
  for_each = { for idx, subnet in local.subnets.web : idx => subnet }

  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "web-subnet-${each.key}"
  }
}

resource "aws_subnet" "private-app" {
  for_each = { for idx, subnet in local.subnets.app : idx => subnet }

  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "app-subnet-${each.key}"
  }
}

resource "aws_subnet" "private-db" {
  for_each = { for idx, subnet in local.subnets.db : idx => subnet }

  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "db-subnet-${each.key}"
  }
}

# Route Tables

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "public-web-rt"
  }
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "private-app-rt"
  }
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "private-db-rt"
  }
}

# Routes

resource "aws_route" "public_web_route" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my-igw.id
}

resource "aws_route" "private_app_route" {
  route_table_id         = aws_route_table.app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my-nat-gw.id
}

resource "aws_route" "private_db_route" {
  route_table_id         = aws_route_table.db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my-nat-gw.id
}

# Route Table Association

resource "aws_route_table_association" "web-rt-asso" {
  for_each       = aws_subnet.public-web
  subnet_id      = each.value.id
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "app-rt-asso" {
  for_each       = aws_subnet.private-app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "db-rt-asso" {
  for_each       = aws_subnet.private-db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.db.id
}

# Security Groups

# resource "aws_security_group" "jump-server" {
#   description = "Jump server sg"
#   vpc_id      = aws_vpc.my-vpc.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (consider restricting this to specific IPs for security)
#   }

#   tags = {
#     Name = "my-jump-server-sg"
#   }
# }

# resource "aws_security_group_rule" "ssh-access-php-sg" {
#   type                     = "egress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.jump-server.id
#   source_security_group_id = aws_security_group.php-sg.id
# }

# resource "aws_security_group" "php-sg" {
#   description = "Allow SSH from the jump server"
#   vpc_id      = aws_vpc.my-vpc.id

#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.jump-server.id]
#   }

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb-sg.id]
#   }

#   egress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     security_groups = [aws_security_group.rds-sg.id]
#   }

#   tags = {
#     Name = "my-php-sg"
#   }
# }

# resource "aws_security_group" "alb-sg" {
#   vpc_id = aws_vpc.my-vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "alb-sg"
#   }
# }

# resource "aws_security_group" "rds-sg" {
#   name        = "rds-sg"
#   description = "Security group for RDS"
#   vpc_id = aws_vpc.my-vpc.id 

#   tags = {
#     Name = "rds-sg"
#   }
# }

# resource "aws_security_group_rule" "rds-ingress" {
#   type              = "ingress"
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   security_group_id = aws_security_group.rds-sg.id
#   source_security_group_id = aws_security_group.php-sg.id
# }

# Key Pair

resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = var.aws_key
}

# EC2

resource "aws_instance" "instances" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  security_groups             = each.value.security_groups
  subnet_id                   = each.value.subnet_id
  tenancy                     = each.value.tenancy
  key_name                    = each.value.key_name
  associate_public_ip_address = each.value.associate_public_ip_address

  tags = {
    name = each.key
  }
  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }
}

# Application Load Balancer

resource "aws_lb" "my-alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public-web["0"].id, aws_subnet.public-web["1"].id]

  tags = {
    Name = "my-alb"
  }
  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }
}

# Target Groups

resource "aws_lb_target_group" "php-target-group" {
  name     = "php-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id

  stickiness {
    type           = "lb_cookie"
    cookie_duration = 3600  // 1 day
  }

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "php-target-group"
  }
}

resource "aws_lb_target_group_attachment" "php-targets" {
  for_each         = local.php_app_instances
  target_group_arn = aws_lb_target_group.php-target-group.arn
  target_id        = each.value.id
  port             = 80
}

# ALB Listeners

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.php-target-group.arn
  }
}

# Subnet Groups

resource "aws_db_subnet_group" "db-subnet-group" {
  name = "db-subnet-group"
  subnet_ids = [
    aws_subnet.private-db["0"].id, // Subnet in us-east-1a
    aws_subnet.private-db["1"].id, // Subnet in us-east-1b
  ]

  tags = {
    Name = "db-subnet-group"
  }
}

# Create RDS MySQL instance
resource "aws_db_instance" "my-db" {
  identifier             = local.rds.identifier
  engine                 = local.rds.engine
  engine_version         = local.rds.engine_version
  instance_class         = local.rds.instance_class
  allocated_storage      = local.rds.allocated_storage
  storage_type           = local.rds.storage_type
  username               = local.rds.username
  password               = local.rds.password
  db_subnet_group_name   = local.rds.subnet_group_name
  publicly_accessible    = local.rds.publicly_accessible
  skip_final_snapshot    = local.rds.skip_final_snapshot
  vpc_security_group_ids = local.rds.vpc_security_group_ids
}

# TESTING TESTING TESTING

resource "aws_security_group" "jump-server" {
  for_each    = local.security_groups.jump-server
  description = each.value.description
  vpc_id      = aws_vpc.my-vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }

  tags = each.value.tags
}

resource "aws_security_group" "php-sg" {
  for_each    = local.security_groups.php-sg
  description = each.value.description
  vpc_id      = aws_vpc.my-vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = lookup(egress.value, "cidr_blocks", [])
      security_groups = lookup(egress.value, "security_groups", [])
    }
  }

  tags = each.value.tags
}

resource "aws_security_group" "alb-sg" {
  for_each    = local.security_groups.alb-sg
  description = each.value.description
  vpc_id      = aws_vpc.my-vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", [])
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = lookup(egress.value, "cidr_blocks", [])
    }
  }

  tags = each.value.tags
}

resource "aws_security_group" "rds-sg" {
  for_each    = local.security_groups.rds-sg
  description = each.value.description
  vpc_id      = aws_vpc.my-vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = lookup(ingress.value, "security_groups", [])
    }
  }

  tags = each.value.tags
}