
output "public_subnet_ids" {
    description = "list of Public Subnet IDs created"
    value       = tolist([
        for subnet_key, subnet in local.subnets : aws_subnet.subnets[subnet_key].id
        if subnet.subnet_type == "web"
    ])
  
}

output "app_private_subnet_ids" {
    description = "list of Application Private Subnet IDs created"
    value       = tolist([
        for subnet_key, subnet in local.subnets : aws_subnet.subnets[subnet_key].id
        if subnet.subnet_type == "app"
    ])
  
}

output "db_private_subnet_ids" {
    description = "list of Database Private Subnet IDs created"
    value = aws_db_subnet_group.db_subnet_group.id
  
}

output "reserved_private_subnet_ids" {
    description = "list of Reserved Private Subnet IDs created"
    value       = tolist([
        for subnet_key, subnet in local.subnets : aws_subnet.subnets[subnet_key].id
        if subnet.subnet_type == "reserved"
    ])
  
}

output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.vpc.id
}


output "db_sg_mysql_id" {
    description = "security group ID for the RDS MySQL"
    value       = aws_security_group.db_sg_mysql.id
  
}

output "public_alb_sg_id" {
    description = "security group ID for the public ALB"
    value       = aws_security_group.public_alb_sg.id
  
}

output "private_alb_sg_id" {
    description = "security group ID for the private ALB"
    value       = aws_security_group.private_alb_sg.id
  
}


output "web_instance_sg_id" {
    description = "security group ID for the web instances"
    value       = aws_security_group.web_instance_sg.id
  
}

output "private_instance_sg_id" {
    description = "security group ID for the private instances"
    value       = aws_security_group.private_instance_sg.id
  
}









