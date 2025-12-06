output "web_alb_dns_name" {
    description = "DNS name of the Web ALB"
    value       = aws_lb.web_alb.dns_name
  
}

output "app_alb_dns_name" {
    description = "DNS name of the App ALB"
    value       = aws_lb.app_alb.dns_name
  
}

