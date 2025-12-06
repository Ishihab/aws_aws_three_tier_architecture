
variable "ami_id" {
  description = "AMI ID for web servers"
  type        = string
  
}
variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
  default     = "t3.micro"
}

variable "web_security_group_ids" {
  description = "List of security group IDs for web servers"
  type        = list(string)
}

variable "web_user_data" {
  description = "User data script for web servers"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type for application servers"
  type        = string
  default     = "t3.micro"
}

variable "app_security_group_ids" {
  description = "List of security group IDs for application servers"
  type        = list(string)
}       

variable "app_user_data" {
  description = "User data script for application servers"
  type        = string
}



