#!/bin/bash
set -e

# Install Node.js if missing
if ! command -v node >/dev/null 2>&1; then
    echo "Node.js not found, installing..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Ensure npm is available
if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found!"
    exit 1
fi

# Navigate to app directory
APP_DIR="/home/ubuntu/app"
if [ ! -d "$APP_DIR" ]; then
    echo "Error: $APP_DIR does not exist"
    exit 1
fi
cd "$APP_DIR"

# Install dependencies
echo "Installing Node.js dependencies..."
npm install

echo "Dependencies installed successfully."