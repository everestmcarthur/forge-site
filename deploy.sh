#!/bin/bash
# Forge Site Deployment Script
# Run on the server (20.84.125.247) to deploy landing page + blog
# Usage: curl -sL https://raw.githubusercontent.com/everestmcarthur/forge-site/main/deploy.sh | bash

set -e

SITE_DIR="/var/www/jarviscli.dev"
REPO="https://github.com/everestmcarthur/forge-site.git"

echo "🔥 Deploying Forge site from GitHub..."

# Backup existing site
if [ -d "$SITE_DIR" ]; then
    cp -r "$SITE_DIR" "${SITE_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    echo "  ✅ Backed up existing site"
fi

# Clone or pull latest
if [ -d "${SITE_DIR}/.git" ]; then
    cd "$SITE_DIR"
    git pull origin main
    echo "  ✅ Pulled latest changes"
else
    # If existing site, move it and clone fresh
    if [ -d "$SITE_DIR" ]; then
        rm -rf "$SITE_DIR"
    fi
    git clone "$REPO" "$SITE_DIR"
    echo "  ✅ Cloned fresh"
fi

# Set permissions
chown -R www-data:www-data "$SITE_DIR" 2>/dev/null || true
chmod -R 755 "$SITE_DIR"

echo ""
echo "🎉 Deployed! Site files are at $SITE_DIR"
echo "   Landing page: /index.html"
echo "   Blog:         /blog/index.html"
echo "   Sitemap:      /sitemap.xml"
echo "   Robots.txt:   /robots.txt"
echo ""
echo "Make sure your Caddyfile serves from $SITE_DIR:"
echo ""
echo '  jarviscli.dev {'
echo '    root * /var/www/jarviscli.dev'
echo '    file_server'
echo '    try_files {path} {path}/index.html {path}.html'
echo '  }'
