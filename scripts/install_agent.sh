#!/bin/bash
set -e

echo "=== Setting up instance ==="

apt-get update -qq
apt-get install -y nginx jq unzip curl wget build-essential

# Install NVM under ubuntu user (NOT root)
sudo -u ubuntu bash -c '
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="/home/ubuntu/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install 20
  nvm use 20
  nvm alias default 20
  npm install -g pm2
'

# Enable CodeDeploy agent debug logging
echo "=== Enabling CodeDeploy debug logging ==="
if [ -f /etc/codedeploy-agent/conf/codedeployagent.conf ]; then
    sed -i '/:log_level:/d' /etc/codedeploy-agent/conf/codedeployagent.conf
    sed -i '/:verbose:/d' /etc/codedeploy-agent/conf/codedeployagent.conf
    echo ":log_level: debug" >> /etc/codedeploy-agent/conf/codedeployagent.conf
    echo ":verbose: true" >> /etc/codedeploy-agent/conf/codedeployagent.conf
    systemctl restart codedeploy-agent || true
    echo "✅ Debug logging enabled"
else
    echo "⚠️ CodeDeploy config not found"
fi

echo "✅ Instance ready"
exit 0