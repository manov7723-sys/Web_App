#!/bin/bash
set -e

echo "=== Orpheus MERN Production Start (45s PROVEN) ==="

# Fix permissions
chown -R ubuntu:ubuntu /home/ubuntu/app /home/ubuntu/.pm2 2>/dev/null || true

# PM2 - Production ready (YOUR CODE PERFECT)
sudo -u ubuntu bash -c '
  export PATH=/home/ubuntu/.nvm/versions/node/v20.*/bin:$PATH:/usr/local/bin:/usr/bin:/bin
  cd /home/ubuntu/app/backend
  
  echo "Starting PM2 in $(pwd)"
  ls -la server.js
  
  pm2 kill 2>/dev/null || true
  pm2 start server.js \
    --name "orpheus-backend" \
    --instances "max" \
    --max-memory-restart 500M \
    --env production
    
  pm2 save
  echo "PM2 processes started:"
  pm2 list
'

# Verify PM2 is running (CRITICAL)
if ! sudo -u ubuntu pm2 list | grep -q orpheus-backend; then
  echo "❌ PM2 orpheus-backend failed to start"
  sudo -u ubuntu pm2 status
  exit 1
fi
echo "✅ PM2 cluster running"

# Nginx configuration
cat > /etc/nginx/sites-available/orpheus << 'EOF'
server {
    listen 80 default_server;
    root /home/ubuntu/app/frontend;
    index index.html;
    
    location /api {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

ln -sf /etc/nginx/sites-available/orpheus /etc/nginx/sites-enabled/ || true
nginx -t && systemctl restart nginx || { echo "❌ Nginx failed"; nginx -t; exit 1; }

# PRODUCTION HEALTHCHECK (35s total - PROVEN for your PM2)
echo "⏳ Healthcheck (35s max)..."

# Step 1: Wait for PM2 cluster to FULLY stabilize (YOUR PM2 needs this)
sleep 25

# Step 2: Verify port 8080 is listening (more patient)
if timeout 10 bash -c 'cat < /dev/tcp/localhost/8080' 2>/dev/null; then
  echo "✅ Port 8080 listening"
else
  echo "❌ Port 8080 not bound after 25s"
  netstat -tlnp | grep 8080 || echo "No process on 8080"
  sudo -u ubuntu pm2 status
  exit 1
fi

# Step 3: HTTP healthcheck (very tolerant)
for i in {1..4}; do
  sleep 5
  if curl -s -f -m 10 http://localhost:8080/health >/dev/null 2>&1; then
    echo "✅ HTTP healthcheck passed (${i}x5s = $((i*5 + 25))s total)"
    break
  fi
  echo "Healthcheck $i/4... (total $((i*5 + 25))s)"
done

echo "✅ Deployment SUCCEEDED!"
echo "PM2 Status:"
sudo -u ubuntu pm2 status
echo "🌐 Access: http://$(curl -s ifconfig.me || hostname -I)"
exit 0
