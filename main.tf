# ============================================================================
# Main Terraform Configuration
# 3-Tier Web Application Infrastructure on AWS
# ============================================================================

# ----------------------------------------------------------------------------
# Data Source: Ubuntu AMI
# Fetches the latest Ubuntu 22.04 LTS AMI
# ----------------------------------------------------------------------------
data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"]  # Canonical

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

# ----------------------------------------------------------------------------
# Module: VPC
# Creates VPC with public/private subnets, NAT gateways, and security groups
# ----------------------------------------------------------------------------
module "vpc" {
    source = "./module/vpc"
    
    # IMPORTANT: Replace with your IP address for SSH access
    ec2_endpoint_allowed_ips = ["YOUR_PUBLIC_IP/32"] # 0.0.0.0/0 to allow all
    
    # Optional: Override default VPC configuration
    # cidr_block = "10.16.0.0/16"
    # number_of_azs = 2
    # enable_ipv6 = true
}

# ----------------------------------------------------------------------------
# Module: EC2 Launch Templates
# Creates launch templates for web and app tiers
# ----------------------------------------------------------------------------
module "ec2" {
    source = "./module/ec2"
    ami_id = data.aws_ami.ubuntu.id

    # Web Tier Configuration
    web_instance_type      = "t3.micro"
    web_security_group_ids = [module.vpc.web_instance_sg_id]
    web_user_data          = filebase64("${path.module}/scripts/web_user_data.sh")

    # Application Tier Configuration
    app_instance_type      = "t3.micro"
    app_security_group_ids = [module.vpc.private_instance_sg_id]
    app_user_data          = filebase64("${path.module}/scripts/app_user_data.sh")
}

# ----------------------------------------------------------------------------
# Module: Application Load Balancers and Auto Scaling Groups
# Creates public ALB, private ALB, and ASGs for web and app tiers
# ----------------------------------------------------------------------------
module "alb_and_asg" {
    source = "./module/app"

    vpc_id = module.vpc.vpc_id

    # Subnet Configuration
    public_subnet_ids  = module.vpc.public_subnet_ids
    private_subnet_ids = module.vpc.app_private_subnet_ids

    # Security Groups
    alb_public_sg_id  = module.vpc.public_alb_sg_id
    alb_private_sg_id = module.vpc.private_alb_sg_id
    
    # Launch Templates
    launch_template_id_app = module.ec2.app_launch_template_id
    launch_template_id_web = module.ec2.web_launch_template_id
    
    # Optional: Override default ASG configuration
    # web_asg_min_size = 2
    # web_asg_max_size = 5
    # web_asg_desired_capacity = 2
    # app_asg_min_size = 2
    # app_asg_max_size = 5
    # app_asg_desired_capacity = 2
}

# ----------------------------------------------------------------------------
# Module: RDS Database
# Creates MySQL database with multi-AZ deployment
# ----------------------------------------------------------------------------
module "rds" {
    source = "./module/rds"

    db_subnet_group_name  = module.vpc.db_private_subnet_ids
    db_security_group_id  = module.vpc.db_sg_mysql_id
    
    # IMPORTANT: Change these credentials or use AWS Secrets Manager
    db_username = "admin"
    # Optional: Override default RDS configuration
    # db_name = "mydatabase"
    # db_instance_class = "db.t3.micro"
    # db_allocated_storage = 20
    # db_engine_version = "8.0"
    # db_backup_retention_period = 7
}



# ============================================================================
# Outputs
# ============================================================================

output "web_alb_dns_name" {
    description = "DNS name of the web-facing Application Load Balancer"
    value       = module.alb_and_asg.web_alb_dns_name
}

output "app_alb_dns_name" {
    description = "DNS name of the internal Application Load Balancer"
    value       = module.alb_and_asg.app_alb_dns_name
}

output "db_instance_endpoint" {
    description = "RDS database endpoint for application connections"
    value       = module.rds.rds_endpoint
}


  



# ============================================================================
# DEPLOYMENT INSTRUCTIONS
# ============================================================================
#
# 1. Update the following values:
#    - ec2_endpoint_allowed_ips: Your public IP address for SSH access
#    - db_password: Use a strong password or AWS Secrets Manager
#
# 2. Update user data scripts:
#    - scripts/web_user_data.sh: Add your web application deployment
#    - scripts/app_user_data.sh: Add your backend application deployment
#
# 3. Configure backend (backend.tf):
#    - Update S3 bucket name
#    - Update DynamoDB table name
#
# 4. Deploy:
#    terraform init
#    terraform plan
#    terraform apply
#
# 5. Access your application:
#    http://<web_alb_dns_name>
#
# ============================================================================
