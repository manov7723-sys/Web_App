#!/bin/bash
set -e

echo "=== Production MERN Start (PM2 Cluster + Nginx) ==="

# Fix permissions first
chown -R ubuntu:ubuntu /home/ubuntu/app /home/ubuntu/.pm2

# Switch to ubuntu user properly
sudo -u ubuntu bash << 'EOF'
  export PATH=/usr/local/bin:/usr/bin:/bin:/home/ubuntu/.nvm/versions/node/v20.*/bin
  cd /home/ubuntu/app/backend
  
  # Kill old processes
  pm2 kill || true
  
  # Start with CLUSTER MODE (uses all CPUs)
  pm2 start server.js \\
    --name "orpheus-backend" \\
    --instances "max" \\
    --max-memory-restart 500M \\
    -i 0 \\
    --env production
  
  pm2 save
  pm2 startup --hp /home/ubuntu
EOF

# Nginx setup
if [ ! -L /etc/nginx/sites-enabled/mern-app ]; then
  ln -sf /etc/nginx/sites-available/mern-app /etc/nginx/sites-enabled/
fi

nginx -t && systemctl restart nginx

# HEALTH CHECK with RETRY (30s timeout)
for i in {1..6}; do
  sleep 5
  if curl -f -m 5 http://localhost:8080/health || curl -f -m 5 http://localhost:8080 2>/dev/null; then
    echo "✅ Backend healthy after ${i*5}s"
    break
  elif [ $i -eq 6 ]; then
    echo "❌ Backend failed healthcheck"
    pm2 logs orpheus-backend --lines 20
    exit 1
  fi
done

echo "🚀 Orpheus MERN deployed! PM2 status:"
sudo -u ubuntu pm2 status
exit 0
