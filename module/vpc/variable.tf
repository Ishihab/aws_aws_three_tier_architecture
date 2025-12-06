variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
  
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.16.0.0/16"
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Assign an IPv6 CIDR block to the VPC"
  type        = bool
  default     = true
}

variable "tags_vpc" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    name = "main_vpc"
    Environment = "development"
  }
} 

variable "subnet_types" {
  type = map(number)
  default = {
    "reserved" = 0
    "web"      = 1
    "app"      = 2
    "db"       = 3
  }
}

variable "ec2_endpoint_allowed_ips" {
  description = "List of CIDR blocks allowed to access the EC2 endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
  
}

variable "number_of_azs" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2
  
}

