#!/bin/bash
# Web Tier User Data for Amazon Linux 2
yum update -y


# Example: Install nginx
amazon-linux-extras install -y nginx1

# Start nginx
systemctl start nginx
systemctl enable nginx

# Add your web application deployment here
