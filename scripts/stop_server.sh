#!/bin/bash
set -e

echo "=== Stopping existing Node.js servers (if any) ==="

# Kill Node.js processes serving your app
pkill -f "/home/ubuntu/app.*node" 2>/dev/null || true
pkill -f "/home/ubuntu/app.*npm"  2>/dev/null || true
pkill -f "npm start"              2>/dev/null || true
pkill -f "node server"            2>/dev/null || true
pkill pm2                         2>/dev/null || true

# Wait for graceful shutdown
sleep 3

# Verify no Node processes remain
if pgrep -f node >/dev/null 2>&1; then
    echo "WARNING: Some Node processes still running"
else
    echo "=== All servers stopped successfully ==="
fi

exit 0
