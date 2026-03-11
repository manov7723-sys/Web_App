#!/bin/bash
set -e

echo "=== Starting Backend ==="

APP_DIR="/home/ubuntu/app"

# Stop old node processes
echo "Stopping existing Node processes..."
pkill -f node || true
sleep 2

cd $APP_DIR/backend

echo "Installing backend dependencies..."
npm install

echo "Starting backend server..."
nohup npm start > backend.log 2>&1 &

echo "Backend started successfully"

sleep 3

echo "=== Backend running ==="