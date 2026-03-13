#!/bin/bash
set -e

echo "=== Installing dependencies ==="

APP_DIR="/home/ubuntu/app"

# Fix parent directory permissions FIRST (NGINX needs to traverse these)
chmod 755 /home/ubuntu
chmod 755 /home/ubuntu/app
chmod 755 /home/ubuntu/app/frontend
chmod 755 /home/ubuntu/app/frontend/dist
chmod -R 755 /home/ubuntu/app/frontend/dist/angular-15-crud

# Single clean NGINX config with proper static file serving
cat > /etc/nginx/sites-available/orpheus << 'EOF'
server {
    listen 80 default_server;
    server_name _;

    root /home/ubuntu/app/frontend/dist/angular-15-crud;
    index index.html;

    # Serve static files directly (JS, CSS, images, fonts)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        root /home/ubuntu/app/frontend/dist/angular-15-crud;
        expires 1y;
        add_header Cache-Control "public, immutable";
        try_files $uri =404;
    }

    # Angular routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API proxy
    location /api/ {
        proxy_pass http://127.0.0.1:8080/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # ALB health check
    location = /health {
        proxy_pass http://127.0.0.1:8080/health;
    }
}
EOF

# Remove old configs, enable only orpheus
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/mern-app
ln -sf /etc/nginx/sites-available/orpheus /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

# Fix ownership FIRST before npm install
chown -R ubuntu:ubuntu /home/ubuntu/app

# Install backend dependencies as ubuntu user
if [ -f "$APP_DIR/backend/package.json" ]; then
    echo "Installing backend dependencies..."
    sudo -u ubuntu bash -c "
        export NVM_DIR='/home/ubuntu/.nvm'
        [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"
        cd $APP_DIR/backend && npm install
    "
fi

# Fix permissions for NGINX
chmod 755 /home/ubuntu
chmod 755 /home/ubuntu/app
chmod 755 /home/ubuntu/app/frontend
chmod 755 /home/ubuntu/app/frontend/dist
chmod -R 755 /home/ubuntu/app/frontend/dist/angular-15-crud
chown -R ubuntu:ubuntu /home/ubuntu/app

echo "✅ Dependencies installed"
exit 0