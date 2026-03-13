#!/bin/bash
set -e

echo "=== Installing dependencies ==="

APP_DIR="/home/ubuntu/app"

# Single clean NGINX config
cat > /etc/nginx/sites-available/orpheus << 'EOF'
server {
    listen 80 default_server;
    server_name _;

   location / {
    root /home/ubuntu/app/frontend/dist/angular-15-crud;
    index index.html;
    try_files $uri /index.html;
}

    location /api/ {
        proxy_pass http://localhost:8080/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ALB health check
    location = /health {
        proxy_pass http://localhost:8080/health;
    }
}
EOF

# Remove old configs, enable only orpheus
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/mern-app
ln -sf /etc/nginx/sites-available/orpheus /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

# Install backend dependencies
if [ -f "$APP_DIR/backend/package.json" ]; then
    sudo -u ubuntu bash -c "
        export NVM_DIR='/home/ubuntu/.nvm'
        [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"
        cd $APP_DIR/backend && npm install
    "
fi

chown -R ubuntu:ubuntu /home/ubuntu/app
echo "✅ Dependencies installed"
exit 0