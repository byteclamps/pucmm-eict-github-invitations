#!/bin/bash

# Define paths
TEMPLATE_PATH="/etc/nginx/templates/default.conf.template"
OUTPUT_PATH="/etc/nginx/conf.d/default.conf"

# Perform environment variable substitution
echo "Substituting environment variables into nginx.conf..."
envsubst '${MOD_CFML_SHARED_KEY},${SSL_BASE_NAME},${NGINX_LOG_LEVEL}' < "$TEMPLATE_PATH" > "$OUTPUT_PATH"

# Validate the generated configuration (optional)
nginx -t || exit 1

# Start Nginx
echo "Starting Nginx..."
nginx

# Execute the existing command
exec /usr/local/bin/run.sh
