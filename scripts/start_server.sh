#!/bin/bash
set -e

echo "=== Starting Backend + Frontend ==="

# Kill existing processes
pkill -f node || true
sleep 2

# Start backend
cd /home/ubuntu/backend
npm start &

echo "Backend started (PID: $!)"
sleep 3

# Backend serves frontend automatically (port 3000)
echo "=== Full MERN stack running on port 3000 ==="
exit 0
