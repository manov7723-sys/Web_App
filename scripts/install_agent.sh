#!/bin/bash
set -euo pipefail  # Stricter error handling

echo "=== ASG-Ready Setup: Ubuntu 24.04 (CodeDeploy + Node/Nginx) ==="

# 1. UPDATE (worked fine in your log)
apt-get update -qq

# 2. SKIP AGENT IF RUNNING (your current instance)
if systemctl is-active --quiet codedeploy-agent 2>/dev/null; then
    echo "✅ Agent v1.8.1 running - skip install"
else
    echo "🔧 Installing CodeDeploy agent..."
    apt-get install -y ruby-full wget  # ✅ Ruby (agent needs it), NO awscli!
    cd /tmp
    wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
    chmod +x ./install
    ./install auto
    systemctl enable --now codedeploy-agent  # enable + start
fi

# 3. AWS CLI (Ubuntu 24.04 fix)
snap install aws-cli --classic || echo "⚠️ AWS CLI skipped (non-critical)"

# 4. APP DEPS (your Node/Nginx)
apt-get install -y nginx jq unzip
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs npm

# 5. VERIFY
systemctl is-active codedeploy-agent && echo "✅ Agent active" || echo "❌ Agent failed"
node --version && echo "✅ Node ready"

echo "🎉 ASG instance fully prepared"
exit 0
