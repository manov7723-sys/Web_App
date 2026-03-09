#!/bin/bash
set -e

echo "=== Starting MERN Backend Server ==="

cd /home/ubuntu/app

# Stop any existing processes first
pkill -f node || true
pkill pm2 || true
sleep 2

# Start with PM2 (production ready)
if command -v pm2 >/dev/null 2>&1; then
    pm2 start server.js --name "mern-server"
    pm2 save
    pm2 startup
else
    # Fallback: npm start
    npm start &
fi

echo "=== Server started successfully ==="
exit 0
