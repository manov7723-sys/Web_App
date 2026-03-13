#!/bin/bash
set -e

echo "=== Validating service ==="

# Wait for ALB health check to pass
for i in {1..12}; do
    if curl -sf http://localhost/health; then
        echo "✅ Service is healthy"
        exit 0
    fi
    echo "Attempt $i/12 - waiting..."
    sleep 5
done

echo "❌ Service failed health check"
exit 1