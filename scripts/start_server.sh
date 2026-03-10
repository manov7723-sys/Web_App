#!/bin/bash
set -e

echo "=== Starting Backend + Frontend ==="

APP_DIR="/home/ubuntu/app"

# Kill existing node processes
echo "Stopping existing Node processes..."
pkill -f node || true
sleep 2

# Start backend
cd $APP_DIR/backend

echo "Starting backend server..."
nohup npm start > backend.log 2>&1 &

echo "Backend started (PID: $!)"

sleep 3

echo "=== MERN backend running ==="
exit 0