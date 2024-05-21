variable "apikey" {
  description = "aws api key"
  type        = string
  sensitive   = true
}

variable "secretkey" {
  description = "aws secret key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  validation {
    condition     = contains(["us-east-1", "us-east-2"], var.region)
    error_message = "Invalid AWS region: us-east-1, us-east-2"
  }
}

# VPC Variables

variable "vpc_cidr" {
  description = "Cidr for the vpc"
  default = "172.20.0.0/20"
}

# Subnet Variables

variable "public_subnet_cidrs_web" {
 type        = list(string)
 description = "Public Web Subnet CIDR values"
 default     = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
}
 
variable "private_subnet_cidrs_app" {
 type        = list(string)
 description = "Private App Subnet CIDR values"
 default     = ["172.20.4.0/24", "172.20.5.0/24", "172.20.6.0/24"]
}