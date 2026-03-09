#!/bin/bash
set -e

echo "=== Stopping existing servers (if any) ==="

# Kill Node.js processes
pkill -f "node.*server" 2>/dev/null || true
pkill -f "npm start"     2>/dev/null || true
pkill pm2                2>/dev/null || true

# Wait for graceful shutdown
sleep 3

echo "=== Server stop complete ==="
exit 0
