output "web_launch_template_id" {
    description = "Launch template ID for web servers"
    value       = aws_launch_template.web_launch_template.id
  
}

output "app_launch_template_id" {
    description = "Launch template ID for app servers"
    value       = aws_launch_template.app_launch_template.id
  
}

