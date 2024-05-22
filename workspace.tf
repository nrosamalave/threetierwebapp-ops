locals {
  vpc_cidr = "10.0.0.0/20"

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