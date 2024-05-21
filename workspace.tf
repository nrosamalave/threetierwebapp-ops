locals {
  vpc_cidr_block = "10.0.0.0/16"
  
  subnets = {
    "us-east-1a" = {
      private_db_subnet  = "10.0.1.0/24"
      public_web_subnet  = "10.0.2.0/24"
      private_app_subnet = "10.0.3.0/24"
    }
    "us-east-1b" = {
      private_db_subnet  = "10.0.4.0/24"
      public_web_subnet  = "10.0.5.0/24"
      private_app_subnet = "10.0.6.0/24"
    }
    "us-east-1c" = {
      private_db_subnet  = "10.0.7.0/24"
      public_web_subnet  = "10.0.8.0/24"
      private_app_subnet = "10.0.9.0/24"
    }
  }
  
  route_tables = ["web", "db", "app"]
}