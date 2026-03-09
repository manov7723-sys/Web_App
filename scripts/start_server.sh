#!/bin/bash
set -e

APP_DIR="/home/ubuntu/app"

# Check if app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "Error: $APP_DIR does not exist"
    exit 1
fi
cd "$APP_DIR"

# Install PM2 if not installed
if ! command -v pm2 >/dev/null 2>&1; then
    echo "PM2 not found, installing..."
    sudo npm install -g pm2
fi

# Stop any existing server process (if running)
if pm2 list | grep -q server; then
    echo "Stopping existing server process..."
    pm2 stop server || true
    pm2 delete server || true
fi

# Start server with PM2
echo "Starting server with PM2..."
pm2 start server.js --name server

# Save PM2 process list to restart on reboot
pm2 save
pm2 startup systemd -u ubuntu --hp /home/ubuntu

echo "Server started successfully."