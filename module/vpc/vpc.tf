
resource "aws_vpc" "vpc" {
    cidr_block           = var.cidr_block
    enable_dns_support   = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames
    assign_generated_ipv6_cidr_block = var.enable_ipv6
    tags = var.tags_vpc
}

resource "aws_ec2_instance_connect_endpoint" "ec2_endpoint" {
    
    subnet_id          = aws_subnet.subnets[local.private_subnet_for_eic].id
    security_group_ids = [aws_security_group.ec2_endpoint_sg.id]
    preserve_client_ip = false
    tags = {
      name = "ec2-endpoint-${local.private_subnet_for_eic}"
    }
  
}

