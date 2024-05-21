locals {
  vpc_cidr_block = "10.0.0.0/16"
  
  az_subnets = {
    "us-east-1a" = [
      { name = "private_db", cidr = "10.0.1.0/24" },
      { name = "public_web", cidr = "10.0.2.0/24" },
      { name = "private_app", cidr = "10.0.3.0/24" },
    ]
    "us-east-1b" = [
      { name = "private_db", cidr = "10.0.4.0/24" },
      { name = "public_web", cidr = "10.0.5.0/24" },
      { name = "private_app", cidr = "10.0.6.0/24" },
    ]
    "us-east-1c" = [
      { name = "private_db", cidr = "10.0.7.0/24" },
      { name = "public_web", cidr = "10.0.8.0/24" },
      { name = "private_app", cidr = "10.0.9.0/24" },
    ]
  }

  flattened_subnets = flatten([
    for az, subnets in local.az_subnets : [
      for subnet in subnets : {
        az         = az
        name       = subnet.name
        cidr_block = subnet.cidr
        key        = "${az}-${subnet.name}"
      }
    ]
  ])

  route_tables = ["web", "db", "app"]
}