# locals {
#   vpc_cidr = "10.0.0.0/20"

#   instances = {
#     jumpserver = {
#       ami                         = "ami-04ff98ccbfa41c9ad"
#       instance_type               = "t2.micro"
#       security_groups             = [aws_security_group.jump-server.id]
#       subnet_id                   = aws_subnet.public-web["0"].id
#       tenancy                     = "default"
#       key_name                    = aws_key_pair.aws-key.key_name
#       associate_public_ip_address = "true"
#     }

#     php-app-1 = {
#       ami                         = "ami-04ff98ccbfa41c9ad"
#       instance_type               = "t2.micro"
#       security_groups             = [aws_security_group.php-sg.id]
#       subnet_id                   = aws_subnet.private-app["0"].id
#       tenancy                     = "default"
#       key_name                    = aws_key_pair.aws-key.key_name
#       associate_public_ip_address = "false"
#     }

#     php-app-2 = {
#       ami                         = "ami-04ff98ccbfa41c9ad"
#       instance_type               = "t2.micro"
#       security_groups             = [aws_security_group.php-sg.id]
#       subnet_id                   = aws_subnet.private-app["1"].id
#       tenancy                     = "default"
#       key_name                    = aws_key_pair.aws-key.key_name
#       associate_public_ip_address = "false"
#     }
#   }

#   subnets = {
#     web = [
#       { cidr = "10.0.1.0/24", az = "us-east-1a" },
#       { cidr = "10.0.2.0/24", az = "us-east-1b" },
#       { cidr = "10.0.3.0/24", az = "us-east-1c" },
#     ]
#     app = [
#       { cidr = "10.0.4.0/24", az = "us-east-1a" },
#       { cidr = "10.0.5.0/24", az = "us-east-1b" },
#       { cidr = "10.0.6.0/24", az = "us-east-1c" },
#     ]
#     db = [
#       { cidr = "10.0.7.0/24", az = "us-east-1a" },
#       { cidr = "10.0.8.0/24", az = "us-east-1b" },
#       { cidr = "10.0.9.0/24", az = "us-east-1c" },
#     ]
#   }

#   php_app_instances = { // referencing php app instances
#     for k, v in aws_instance.instances : k => v
#     if k == "php-app-1" || k == "php-app-2"
#   }

#   rds = {
#     identifier             = "my-db"
#     engine                 = "mysql"
#     engine_version         = "5.7"
#     instance_class         = "db.t3.micro"
#     allocated_storage      = 20
#     storage_type           = "gp2"
#     username               = var.rds_username
#     password               = var.rds_password
#     subnet_group_name      = "db-subnet-group"
#     publicly_accessible    = false
#     skip_final_snapshot    = false
#     vpc_security_group_ids = [aws_security_group.rds-sg.id]
#   }
# }

