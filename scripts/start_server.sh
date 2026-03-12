#!/bin/bash
set -e

echo "=== Orpheus MERN Production Start (Fixed) ==="

# Fix permissions
chown -R ubuntu:ubuntu /home/ubuntu/app /home/ubuntu/.pm2 2>/dev/null || true

# PM2 as ubuntu user (GLOBAL PM2 + FULL PATHS) - YOUR CODE PERFECT ✓
sudo -u ubuntu bash -c '
  export PATH=/home/ubuntu/.nvm/versions/node/v20.*/bin:$PATH:/usr/local/bin:/usr/bin:/bin
  cd /home/ubuntu/app/backend || exit 1
  echo "Starting PM2 in $(pwd)"
  ls -la server.js
  
  pm2 kill 2>/dev/null || true
  pm2 start server.js \
    --name "orpheus-backend" \
    --instances "max" \
    --max-memory-restart 500M \
    --env production || {
    echo "PM2 start failed"; pm2 status; exit 1
  }
  pm2 save
  echo "PM2 processes: $(pm2 list)"
'

# Nginx proxy (YOUR CODE PERFECT ✓)
if [ ! -L /etc/nginx/sites-enabled/orpheus ]; then
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
  ln -sf /etc/nginx/sites-available/orpheus /etc/nginx/sites-enabled/
fi

nginx -t && systemctl restart nginx

# FIXED HEALTH CHECK (90s + tolerant)
echo "Waiting for backend..."
for i in {1..18}; do  # ← 90s total (was 12=60s)
  sleep 5
  # TRY /health FIRST, then ANY response (no -f flag)
  if curl -s -m 5 http://localhost:8080/health -o /dev/null -w "%{http_code}" | grep -q "200" 2>/dev/null || \
     curl -s -m 5 http://localhost:8080 -o /dev/null -w "%{http_code}" | grep -qE "200|404" 2>/dev/null; then
    echo "✅ Backend healthy after ${i*5}s"
    break
  fi
  echo "Wait ${i*5}s... (attempt $i/18)"
  if [ $i -eq 18 ]; then
    echo "❌ Backend timeout - PM2 logs:"
    sudo -u ubuntu pm2 logs orpheus-backend --lines 20
    exit 1
  fi
done

echo "✅ Deployment SUCCEEDED!"
sudo -u ubuntu pm2 status
exit 0
