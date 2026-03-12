#!/bin/bash
set -euo pipefail

echo "=== FIXED: Ubuntu 24.04 ASG Setup ==="

# Agent check (skip if running)
systemctl is-active codedeploy-agent >/dev/null 2>&1 && echo "✅ Agent OK" || echo "⚠️ Agent check"

# Core deps (nginx stays apt)
apt-get update -qq
apt-get install -y nginx jq unzip curl wget build-essential

# NVM + Node 20 (bypasses ALL apt dependency issues)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="/root/.nvm"  # root user for CodeDeploy
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

nvm install 20
nvm use 20
nvm alias default 20

# Verify
node --version | grep "v20" && echo "✅ Node 20 ready"
npm --version && echo "✅ npm ready"

echo "🎉 ASG instance ready!"
exit 0
