variable "private_subnet_ids" {
  description = "List of subnet IDs"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  
}

variable "alb_public_sg_id" {
  description = "Security Group ID for the public ALB"
  type        = string
}

variable "alb_private_sg_id" {
  description = "Security Group ID for the private ALB"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "web_asg_max_size" {
  description = "Maximum size of the web ASG"
  type        = number
  default     = 3
  
}

variable "web_asg_min_size" {
  description = "Minimum size of the web ASG"
  type        = number
  default     = 1
  
}

variable "web_asg_desired_capacity" {
  description = "Desired capacity of the web ASG"
  type        = number
  default     = 2
  
}   

variable "app_asg_max_size" {
  description = "Maximum size of the app ASG"
  type        = number
  default     = 3
  
}


variable "app_asg_min_size" {
  description = "Minimum size of the app ASG"
  type        = number
  default     = 1
  
}

variable "app_asg_desired_capacity" {
  description = "Desired capacity of the app ASG"
  type        = number
  default     = 2
  
}

variable "launch_template_id_web" {
  description = "Launch template ID for web servers"
  type        = string
}

variable "launch_template_id_app" {
  description = "Launch template ID for app servers"
  type        = string
}

