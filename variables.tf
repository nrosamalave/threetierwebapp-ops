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

variable "aws_key" {
  description = "The public key to be used for SSH access"
  type        = string
  sensitive   = true
}

variable "rds_username" {
  description = "RDS username"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}