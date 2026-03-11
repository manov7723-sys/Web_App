#!/bin/bash
set -e

echo "=== Installing NGINX + Node.js + PM2 + Dependencies ==="

# Install NGINX
if ! command -v nginx >/dev/null 2>&1; then
    echo "NGINX not found, installing..."
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "✅ NGINX installed"
else
    echo "✅ NGINX already installed"
fi

# Install Node.js if missing
if ! command -v node >/dev/null 2>&1; then
    echo "Node.js not found, installing Node.js 20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "✅ Node.js already installed: $(node --version)"
fi

# Ensure npm is available
if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found!"
    exit 1
fi

APP_DIR="/home/ubuntu/app"

if [ ! -d "$APP_DIR" ]; then
    echo "Error: $APP_DIR does not exist"
    exit 1
fi

# Configure NGINX for MERN stack
cat > /etc/nginx/sites-available/mern-app << 'EOF'
server {
    listen 80;
    server_name _;

    # Frontend React (static files)
    location / {
        root /home/ubuntu/app/frontend/build;
        index index.html;
        try_files $uri /index.html;
    }

    # Backend API proxy (remove trailing slash for clean URLs)
    location /api {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Health check direct to backend (for ALB Target Group)
    location = /health {
        proxy_pass http://localhost:8080/health;
    }
}
EOF

# Enable NGINX site
ln -sf /etc/nginx/sites-available/mern-app /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx

# Install PM2 globally (safe with NodeSource)
if ! command -v pm2 >/dev/null 2>&1; then
    echo "PM2 not found, installing globally..."
    sudo npm install -g pm2
else
    echo "✅ PM2 already installed"
fi

# Install backend dependencies + PM2 locally
if [ -f "$APP_DIR/backend/package.json" ]; then
    echo "Installing backend dependencies..."
    cd $APP_DIR/backend
    npm install
    npm install pm2 --save-dev  # Local PM2 fallback
    chown -R ubuntu:ubuntu /home/ubuntu/app/backend
else
    echo "No backend/package.json found"
fi

# Install frontend dependencies
if [ -f "$APP_DIR/frontend/package.json" ]; then
    echo "Installing frontend dependencies..."
    cd $APP_DIR/frontend
    npm install
    chown -R ubuntu:ubuntu /home/ubuntu/app/frontend
else
    echo "No frontend/package.json found"
fi

# Final permissions
chown -R ubuntu:ubuntu /home/ubuntu/app

echo "✅ NGINX + Node.js + PM2 + Dependencies installed successfully!"
echo "NGINX config: /etc/nginx/sites-available/mern-app"
echo "Backend ready at: http://localhost:8080"
echo "Frontend served at: http://localhost:80"
