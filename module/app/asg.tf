resource "aws_autoscaling_group" "web_asg" {
    name                      = "web-asg"
    max_size                  = var.web_asg_max_size
    min_size                  = var.web_asg_min_size
    desired_capacity          = var.web_asg_desired_capacity
    vpc_zone_identifier       = var.public_subnet_ids
    launch_template {
        id      = var.launch_template_id_web
        version = "$Latest"
    }
    target_group_arns         = [aws_lb_target_group.web_tg.arn]
}

resource "aws_autoscaling_group" "app_asg" {
    name                      = "app-asg"
    max_size                  = var.app_asg_max_size
    min_size                  = var.app_asg_min_size
    desired_capacity          = var.app_asg_desired_capacity
    vpc_zone_identifier       = var.private_subnet_ids
    launch_template {
        id      = var.launch_template_id_app
        version = "$Latest"
    }
    target_group_arns         = [aws_lb_target_group.app_tg.arn]
}
