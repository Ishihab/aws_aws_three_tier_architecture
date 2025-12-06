resource "aws_launch_template" "web_launch_template" {
    name_prefix   = "web-launch-template-"
    image_id      = var.ami_id
    instance_type = var.web_instance_type
    iam_instance_profile {
        name = aws_iam_instance_profile.ec2_instance_profile.name
    }

    network_interfaces {
        associate_public_ip_address = false
        security_groups             = var.web_security_group_ids
    }

    user_data = var.web_user_data
  
}

resource "aws_launch_template" "app_launch_template" {
    name_prefix   = "app-launch-template-"
    image_id      = var.ami_id
    instance_type = var.app_instance_type

    iam_instance_profile {
        name = aws_iam_instance_profile.ec2_instance_profile.name
    }

    network_interfaces {
        associate_public_ip_address = false
        security_groups             = var.app_security_group_ids
    }

    user_data = var.app_user_data
  
}