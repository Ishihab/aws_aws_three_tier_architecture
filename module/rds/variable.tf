variable "db_identifier" {
  description = "The RDS DB instance identifier"
  type        = string  
  default = "mydbinstance"
  
}

variable "db_instance_class" {
  description = "The RDS DB instance class"
  type        = string
  default     = "db.t3.micro"
}


variable "db_engine" {
  description = "The RDS DB engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The RDS DB engine version"
  type        = string
  default     = "8.0"
  
}

variable "db_username" {
  description = "The master username for the RDS DB instance"
  type        = string
}


variable "db_name" {
  description = "The name of the initial database to create"
  type        = string
  default     = "mydatabase"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 8
}


variable "db_security_group_id" {
  description = "The security group ID to associate with the RDS instance"
  type        = string
}

variable "db_subnet_group_name" {
  description = "The DB subnet group name"
  type        = string
}

variable "db_backup_retention_period" {
  description = "The backup retention period in days"
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}


variable "db_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "Sun:04:00-Sun:04:30"
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "db_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 60
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with the RDS instance"
  type        = string
  default     = "parameter-group"
  
}

variable "tags_db" {
  description = "A map of tags to assign to the RDS instance"
  type        = map(string)
  default     = {
    Environment = "development"
    name       = "my-rds-instance"
  }
}

