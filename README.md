# AWS 3-Tier Web Application Infrastructure

A production-ready, highly available 3-tier web application infrastructure deployed on AWS using Terraform. This architecture implements security best practices, auto-scaling, and complete separation of concerns across presentation, application, and data layers.

## 🏗️ Architecture Overview

This infrastructure implements a classic 3-tier architecture:

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                 │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                    ┌──────▼──────┐
                    │   Public    │
                    │     ALB     │  ◄── HTTPS/HTTP (443/80)
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │         Public Subnets (Web Tier)   │
        │  ┌─────────┐  ┌─────────┐           │
        │  │  Web    │  │  Web    │           │
        │  │ Instance│  │ Instance│  ◄── Auto Scaling
        │  └────┬────┘  └────┬────┘           │
        └───────┼────────────┼─────────────────┘
                │            │
         ┌──────▼────────────▼──────┐
         │   Private ALB (Internal) │
         └──────────┬────────────────┘
                    │
        ┌───────────┼──────────────────────┐
        │   Private Subnets (App Tier)     │
        │  ┌─────────┐  ┌─────────┐        │
        │  │  App    │  │  App    │        │
        │  │ Instance│  │ Instance│  ◄── Auto Scaling
        │  └────┬────┘  └────┬────┘        │
        └───────┼────────────┼──────────────┘
                │            │
                └─────┬──────┘
                      │
        ┌─────────────▼──────────────────┐
        │  Private Subnets (Data Tier)   │
        │  ┌──────────────────────┐      │
        │  │   RDS MySQL          │      │
        │  │   Multi-AZ           │      │
        │  │   Encrypted          │      │
        │  └──────────────────────┘      │
        └─────────────────────────────────┘
```

## ✨ Features

### 🔒 Security
- **Multi-AZ Deployment** for high availability
- **Security Groups** with least-privilege access
- **Private Subnets** for application and database tiers
- **EC2 Instance Connect Endpoint** for secure SSH access (no bastion host needed)
- **Encrypted RDS** with KMS encryption
- **Secrets Manager** for secure database password storage
- **IAM Roles** with minimal required permissions
- **IPv6 Support** with dual-stack configuration

### 🚀 High Availability & Scalability
- **Auto Scaling Groups** for web and application tiers
- **Application Load Balancers** for traffic distribution
- **Multi-AZ RDS** with automated backups
- **NAT Gateways** in each availability zone
- **Health Checks** for automatic recovery

### 📊 Monitoring & Management
- **RDS Enhanced Monitoring** with CloudWatch
- **Custom Parameter Groups** for database tuning
- **SSM Parameter Store** for configuration management
- **Backup Windows** for automated database backups
- **Maintenance Windows** for automated patching

### 🛠️ Infrastructure as Code
- **Modular Design** for reusability
- **Remote State** with S3 backend and locking
- **Terraform 1.4+** with latest AWS provider
- **Well-documented** configuration with inline comments

## 📁 Project Structure

```
terraform_three_tier_arch/
├── main.tf                      # Main orchestration file
├── variable.tf                  # Root-level variables
├── providers.tf                 # AWS provider configuration
├── backend.tf                   # S3 backend configuration
├── terraform.tf                 # Terraform version constraints
│
├── module/
│   ├── vpc/                     # VPC Module
│   │   ├── vpc.tf              # VPC resource
│   │   ├── subnets.tf          # Subnet configuration
│   │   ├── gatway.tf           # Internet & NAT gateways
│   │   ├── route_table.tf      # Route tables
│   │   ├── sg.tf               # Security groups
│   │   ├── data.tf             # Data sources
│   │   ├── locals.tf           # Local values
│   │   ├── outputs.tf          # VPC outputs
│   │   └── variable.tf         # VPC variables
│   │
│   ├── ec2/                     # EC2 Module
│   │   ├── launch_template.tf  # Launch templates
│   │   ├── role_policy.tf      # IAM roles & policies
│   │   ├── outputs.tf          # EC2 outputs
│   │   └── variable.tf         # EC2 variables
│   │
│   ├── app/                     # ALB & ASG Module
│   │   ├── alb.tf              # Load balancers
│   │   ├── target_group.tf     # Target groups
│   │   ├── listener.tf         # ALB listeners
│   │   ├── asg.tf              # Auto Scaling Groups
│   │   ├── outputs.tf          # ALB outputs
│   │   └── variable.tf         # ALB variables
│   │
│   └── rds/                     # RDS Module
│       ├── db.tf               # RDS instance
│       ├── outputs.tf          # RDS outputs
│       └── variable.tf         # RDS variables
│
└── scripts/
    ├── web_user_data.sh        # Web tier initialization
    └── app_user_data.sh        # App tier initialization
```

## 🎯 Prerequisites

- **Terraform** >= 1.4
- **AWS CLI** configured with appropriate credentials
- **AWS Account** with sufficient permissions
- **S3 Bucket** for Terraform state (update in `backend.tf`)

## 🚀 Quick Start

### 1. Clone and Configure

```bash
git clone git@github.com:Ishihab/aws_three_tier_architecture.git
cd terraform_three_tier_arch
```

### 2. Update Configuration

**Required Changes:**

Edit `main.tf` and update:
```hcl
module "vpc" {
  source = "./module/vpc"
  
  # IMPORTANT: Replace with your public IP
  ec2_endpoint_allowed_ips = ["YOUR_PUBLIC_IP/32"]
}
```

Edit `backend.tf`:
```hcl
terraform {
  backend "s3" {
    bucket = "YOUR-TERRAFORM-STATE-BUCKET"  # Update this
    key    = "simple_social/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

**Deployment time: ~15-20 minutes**

### 6. Get Outputs

```bash
terraform output
```

You'll receive:
- `web_alb_dns_name` - Public ALB endpoint
- `app_alb_dns_name` - Internal ALB endpoint
- `db_instance_endpoint` - RDS database endpoint

## 🔧 Configuration Options

### VPC Configuration

```hcl
module "vpc" {
  source = "./module/vpc"
  
  cidr_block    = "10.16.0.0/16"  # Default VPC CIDR
  number_of_azs = 2               # Number of AZs to use
  enable_ipv6   = true            # Enable IPv6 support
}
```

### Auto Scaling Configuration

```hcl
module "alb_and_asg" {
  source = "./module/app"
  
  # Web Tier Scaling
  web_asg_min_size         = 2
  web_asg_max_size         = 5
  web_asg_desired_capacity = 2
  
  # App Tier Scaling
  app_asg_min_size         = 2
  app_asg_max_size         = 5
  app_asg_desired_capacity = 2
}
```

### RDS Configuration

```hcl
module "rds" {
  source = "./module/rds"
  
  db_name                   = "mydatabase"
  db_instance_class         = "db.t3.micro"
  db_allocated_storage      = 20
  db_engine_version         = "8.0"
  db_backup_retention_period = 7
  db_multi_az               = true
}
```

## 🔐 Security Features

### Network Security

| Component | Security Group | Allowed Inbound | Allowed Outbound |
|-----------|---------------|-----------------|------------------|
| **Public ALB** | `public_alb_sg` | 80, 443 from 0.0.0.0/0 | All |
| **Web Instances** | `web_instance_sg` | 80 from public_alb_sg<br>22 from ec2_endpoint_sg | All |
| **Private ALB** | `private_alb_sg` | 80 from web_instance_sg | All |
| **App Instances** | `private_instance_sg` | 80 from private_alb_sg<br>22 from ec2_endpoint_sg | All |
| **RDS MySQL** | `db_sg_mysql` | 3306 from private_instance_sg | All |
| **EIC Endpoint** | `ec2_endpoint_sg` | 22 from your IP | All |

### Access Management

**SSH Access via EC2 Instance Connect:**
```bash
# Connect to web tier instance
aws ec2-instance-connect ssh \
  --instance-id <INSTANCE_ID> \
  --region us-east-1

# Connect to app tier instance (same command)
```

**Database Password Retrieval:**
```bash
# Get RDS password from Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id db_password \
  --region us-east-1 \
  --query SecretString \
  --output text
```

**RDS Endpoint Retrieval:**
```bash
# Get RDS endpoint from SSM Parameter Store
aws ssm get-parameter \
  --name /rds/rds_instance_endpoint \
  --region us-east-1 \
  --with-decryption \
  --query Parameter.Value \
  --output text
```

## 📝 Application Deployment

### Web Tier (`scripts/web_user_data.sh`)

Edit the script to deploy your web application:

```bash
#!/bin/bash
apt update
apt install -y nginx

# Deploy your application
# Example: Pull from S3, Git, etc.
```

### App Tier (`scripts/app_user_data.sh`)

Edit the script to deploy your application server:

```bash
#!/bin/bash
apt update
apt install -y python3 python3-pip

# Get database credentials
DB_ENDPOINT=$(aws ssm get-parameter \
  --name /rds/rds_instance_endpoint \
  --region us-east-1 \
  --query Parameter.Value \
  --output text)

DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id db_password \
  --region us-east-1 \
  --query SecretString \
  --output text)

# Deploy your application with DB connection
```

## 🗄️ Database Connection

### From App Instances

```bash
# Get credentials
DB_ENDPOINT=$(aws ssm get-parameter \
  --name /rds/rds_instance_endpoint \
  --region us-east-1 \
  --query Parameter.Value \
  --output text)

DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id db_password \
  --region us-east-1 \
  --query SecretString \
  --output text)

# Connect to database
mysql -h ${DB_ENDPOINT%:*} -u admin -p${DB_PASSWORD} mydatabase
```

### Connection String Format

```
Host: <rds_endpoint>
Port: 3306
Database: mydatabase
Username: admin
Password: <from_secrets_manager>
```

## 📊 Monitoring

### RDS Monitoring

- **Enhanced Monitoring**: 60-second interval
- **Backup Retention**: 7 days (configurable)
- **Backup Window**: 03:00-04:00 UTC
- **Maintenance Window**: Sun:04:00-Sun:05:00 UTC

### CloudWatch Metrics

All resources automatically send metrics to CloudWatch:
- EC2 instance metrics
- ALB metrics (request count, latency, errors)
- RDS metrics (CPU, storage, connections)
- Auto Scaling metrics

## 💰 Cost Optimization

### Estimated Monthly Cost (us-east-1)

| Resource | Configuration | Estimated Cost |
|----------|--------------|----------------|
| EC2 (t3.micro) | 4 instances | ~$30 |
| RDS (db.t3.micro) | Multi-AZ | ~$30 |
| NAT Gateway | 2 AZs | ~$65 |
| ALB | 2 load balancers | ~$35 |
| Data Transfer | Variable | ~$10 |
| **Total** | | **~$170/month** |

### Cost Reduction Tips

1. **Single AZ for dev/test**: Set `db_multi_az = false`
2. **Reduce NAT Gateways**: Use 1 NAT Gateway for dev
3. **Instance Sizing**: Use smaller instances for testing
4. **Reserved Instances**: For production workloads
5. **Auto Scaling**: Set lower min/max values for non-peak

## 🔄 Infrastructure Updates

### Updating the Infrastructure

```bash
# Make changes to .tf files
terraform plan

# Review changes
terraform apply
```

### Rolling Updates

Auto Scaling Groups automatically perform rolling updates when launch templates change.

### Database Modifications

⚠️ **Warning**: Some RDS changes require downtime. Review the plan carefully.

## 🧹 Cleanup

### Destroy All Resources

```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete all resources, including databases!

### Manual Cleanup Required

After `terraform destroy`, manually delete:
- S3 bucket (Terraform state)
- CloudWatch log groups
- Secrets Manager secrets (if retention policy is set)

## 🐛 Troubleshooting

### Common Issues

**Issue**: "Unknown host" error when connecting to RDS
```bash
# Solution 1: Check DNS resolution
nslookup <rds-endpoint>

# Solution 2: Verify security groups
aws ec2 describe-security-groups --group-ids <sg-id>

# Solution 3: Ensure instance has IAM role for SSM/Secrets Manager
```

**Issue**: Cannot SSH to instances
```bash
# Verify your IP is allowed
# Update ec2_endpoint_allowed_ips in main.tf
# Apply changes: terraform apply
```

**Issue**: ALB returns 503 errors
```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn>

# Verify instances are running
# Check security group rules
```

**Issue**: Terraform state lock
```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

## 📚 Module Documentation

### VPC Module

Creates a VPC with:
- **4 subnet tiers** per AZ: Reserved, Web (public), App (private), DB (private)
- **Internet Gateway** for public subnets
- **NAT Gateways** in each AZ for private subnet internet access
- **Route Tables** with proper routing
- **Security Groups** for all tiers
- **EC2 Instance Connect Endpoint** for secure SSH access

### EC2 Module

Creates:
- **Launch Templates** for web and app tiers
- **IAM Roles** with SSM and Secrets Manager permissions
- **Instance Profiles** attached to launch templates

### App Module

Creates:
- **Public ALB** for internet-facing traffic
- **Private ALB** for internal communication
- **Target Groups** with health checks
- **Auto Scaling Groups** for both tiers
- **HTTP Listeners** (HTTPS can be configured)

### RDS Module

Creates:
- **RDS MySQL Instance** with encryption
- **DB Subnet Group** spanning multiple AZs
- **Parameter Group** with custom settings
- **Secrets Manager** for password storage
- **SSM Parameter** for endpoint storage
- **KMS Key** for encryption
- **IAM Role** for enhanced monitoring

## 🤝 Contributing

Feel free to submit issues or pull requests for improvements.

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Sohrab

## 🔗 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [EC2 Instance Connect Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html)

---

**Note**: This infrastructure is designed for production use but should be customized based on your specific requirements, security policies, and compliance needs.
