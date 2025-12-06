

resource "aws_lb" "web_alb" {
    name               = "web-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.alb_public_sg_id]
    subnets            = var.public_subnet_ids
}


resource "aws_lb" "app_alb" {
    name               = "app-alb"
    internal           = true
    load_balancer_type = "application"
    security_groups    = [var.alb_private_sg_id]
    subnets            = var.private_subnet_ids
  
}


resource "aws_ssm_parameter" "web_alb_dns_name" {
    name  = "/alb/web_alb_dns_name"
    type  = "String"
    value = aws_lb.web_alb.dns_name
  
}

resource "aws_ssm_parameter" "app_alb_dns_name" {
    name  = "/alb/app_alb_dns_name"
    type  = "String"
    value = aws_lb.app_alb.dns_name
  
}



