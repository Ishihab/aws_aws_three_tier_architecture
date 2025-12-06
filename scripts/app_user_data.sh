#!/bin/bash
# App Tier User Data for Amazon Linux 2
yum update -y


# Get database credentials from AWS services
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

# Install MySQL client
yum install -y mysql

# Example: Install Python 3
yum install -y python3 python3-pip

# Create environment file with database connection details
cat > /home/ec2-user/.env <<EOF
DB_HOST=${DB_ENDPOINT%:*}
DB_PORT=3306
DB_NAME=mydatabase
DB_USER=admin
DB_PASSWORD=${DB_PASSWORD}
EOF

chown ec2-user:ec2-user /home/ec2-user/.env
chmod 600 /home/ec2-user/.env

# Add your application deployment here
