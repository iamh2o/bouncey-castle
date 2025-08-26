#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/opt/bouncey-castle"
ENV_NAME="bouncey-castle"
DOMAIN="${DOMAIN:-example.com}"

if ! command -v conda >/dev/null 2>&1; then
  curl -sSLo /tmp/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash /tmp/miniconda.sh -b -p /opt/conda
  export PATH="/opt/conda/bin:$PATH"
fi

conda env create -f environment.yml || conda env update -f environment.yml

mkdir -p "$REPO_DIR"
cp -R . "$REPO_DIR"

cp service/bouncey-castle.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable bouncey-castle.service
systemctl restart bouncey-castle.service

apt-get update
apt-get install -y apache2 certbot python3-certbot-apache

cp config/apache-bouncey-castle.conf /etc/apache2/sites-available/bouncey-castle.conf
a2enmod proxy proxy_http ssl
a2ensite bouncey-castle.conf
systemctl reload apache2

certbot --apache -d "$DOMAIN" -n --agree-tos --register-unsafely-without-email
