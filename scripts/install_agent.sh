#!/bin/bash
set -e

echo "=== Installing CodeDeploy Agent + Base Dependencies ==="

# Update system
apt-get update

# Install AWS CLI + CodeDeploy agent
apt-get install -y awscli

# Download and install agent
aws s3 cp s3://aws-codedeploy-us-east-1/latest/install /tmp/install --region us-east-1
chmod +x /tmp/install
/tmp/install auto

# Start agent
systemctl enable codedeploy-agent
systemctl start codedeploy-agent

# Install NGINX + Node.js base
apt-get install -y nginx

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs npm

echo "✅ CodeDeploy agent + base deps installed"
