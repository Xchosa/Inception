#!/bin/bash

set -e

# Load environment variables from src/.env
if [ -f "./src/.env" ]; then
    source ./src/.env
else
    echo "Error: ./src/.env not found"
    exit 1
fi

# Create temporary hosts file with variables resolved
cat > /tmp/hosts.tmp << EOF
127.0.0.1	${Domain_NAME}

EOF

# Copy to actual hosts file (requires sudo)
sudo cp /tmp/hosts.tmp /etc/hosts
rm /tmp/hosts.tmp

echo "Hosts file updated with Domain_NAME: ${Domain_NAME}"