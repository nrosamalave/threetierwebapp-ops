locals {
  vpc_cidr = "10.0.0.0/20"

  instances = {
    jumpserver = {
      ami             = "ami-04ff98ccbfa41c9ad"
      instance_type   = "t2.micro"
      security_groups = [aws_security_group.jump-server.id]
      subnet_id = aws_subnet.public-web["0"].id
      tenancy     = "default"
      key_name    = aws_key_pair.aws-key.key_name
      associate_public_ip_address = "true"
    }

    php-app-1 = {
      ami             = "ami-04ff98ccbfa41c9ad"
      instance_type   = "t2.micro"
      security_groups = [aws_security_group.php-sg.id]
      subnet_id = aws_subnet.private-app["0"].id
      tenancy     = "default"
      key_name    = aws_key_pair.aws-key.key_name
      associate_public_ip_address = "false"
    }

    php-app-2 = {
      ami             = "ami-04ff98ccbfa41c9ad"
      instance_type   = "t2.micro"
      security_groups = [aws_security_group.php-sg.id]
      subnet_id = aws_subnet.private-app["1"].id
      tenancy     = "default"
      key_name    = aws_key_pair.aws-key.key_name
      associate_public_ip_address = "false"
    }
  }

  subnets = {
    web = [
      { cidr = "10.0.1.0/24", az = "us-east-1a" },
      { cidr = "10.0.2.0/24", az = "us-east-1b" },
      { cidr = "10.0.3.0/24", az = "us-east-1c" },
    ]
    app = [
      { cidr = "10.0.4.0/24", az = "us-east-1a" },
      { cidr = "10.0.5.0/24", az = "us-east-1b" },
      { cidr = "10.0.6.0/24", az = "us-east-1c" },
    ]
    db = [
      { cidr = "10.0.7.0/24", az = "us-east-1a" },
      { cidr = "10.0.8.0/24", az = "us-east-1b" },
      { cidr = "10.0.9.0/24", az = "us-east-1c" },
    ]
  }
}
