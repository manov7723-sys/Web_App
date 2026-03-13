#!/bin/bash
set -e

echo "=== Starting application ==="

sudo -u ubuntu bash -c '
    export NVM_DIR="/home/ubuntu/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    cd /home/ubuntu/app/backend

    pm2 delete orpheus-backend 2>/dev/null || true
    pm2 start server.js --name orpheus-backend --instances max --env production
    pm2 save
    pm2 list
'

# Fix permissions for NGINX after PM2 start
chmod 755 /home/ubuntu
chmod -R 755 /home/ubuntu/app/frontend/dist
chown -R ubuntu:ubuntu /home/ubuntu/app

# Wait and validate
sleep 5
curl -sf http://localhost:8080/health || { echo "❌ Backend not responding on 8080"; exit 1; }
curl -sf http://localhost/health || { echo "❌ NGINX health check failed"; exit 1; }

echo "✅ Application started successfully"
exit 0