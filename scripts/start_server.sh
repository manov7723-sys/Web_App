#!/bin/bash
set -e

echo "=== Starting MERN Stack Servers ==="

cd /home/ubuntu/app/backend

# Clean PM2 + Start fresh
npx pm2 delete all || true
npx pm2 start server.js --name "mern-backend"
npx pm2 save

# Health checks
sleep 5
if curl -f http://localhost:8080 >/dev/null 2>&1; then
    echo "✅ Backend healthy (port 8080)"
else
    echo "❌ Backend health check FAILED"
    exit 1
fi

if curl -f http://localhost >/dev/null 2>&1; then
    echo "✅ Frontend via NGINX (port 80)"
else
    echo "⚠️ Frontend NGINX check failed (normal first time)"
fi

systemctl restart nginx
echo "🚀 MERN + NGINX stack deployed successfully!"
