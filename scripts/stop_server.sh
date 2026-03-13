#!/bin/bash

echo "=== Stopping application ==="

sudo -u ubuntu bash -c '
    export NVM_DIR="/home/ubuntu/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    pm2 delete orpheus-backend 2>/dev/null || true
    pm2 save 2>/dev/null || true
' || true

sleep 2
echo "✅ Application stopped"
exit 0