variable "cidr_block" {
    description = "Map of cidr to VPC"
    type        = map(any)
}

# Subnet variables

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

variable "private_subnet_cidrs_db" {
 type        = list(string)
 description = "Private DB Subnet CIDR values"
 default     = ["172.20.7.0/24", "172.20.8.0/24", "172.20.9.0/24"]
}