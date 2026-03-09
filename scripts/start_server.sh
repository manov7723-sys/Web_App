#!/bin/bash
set -e

echo "=== Starting MERN Backend Server ==="

cd /home/ubuntu/app

# Kill existing processes
pkill -f node || true
sleep 2

# Use npm start (matches your package.json)
npm start &

echo "=== Server started successfully (PID: $!) ==="
sleep 5
exit 0
