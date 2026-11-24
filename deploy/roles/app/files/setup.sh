#!/bin/sh
set -e

until [ -f /var/www/html/wp-config.php ]; do
  sleep 2
done

if ! wp core is-installed; then
  wp core install \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email
  echo "WP_INSTALLED_NOW"
fi
