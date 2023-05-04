#!/bin/sh

echo -n "Populating Telegraf configs to Docker volume ... "
cp -r /config/telegraf/* /telegraf/ && echo "Done." || { echo "Error!" && exit 1; }

echo -n " Creating config directory structure for NGINX .. "
mkdir -p /swag/nginx/proxy_configs/ && echo "Done." || { echo "Error!" && exit 1; }

echo -n "Populating NGINX proxy configs to Docker volume ... "
cp -r /config/proxy/* /swag/nginx/proxy_configs/ && echo "Done." || { echo "Error!" && exit 1; }

echo -n "Populating htpasswd file(s) to Docker volume ... "
cp -r /config/htpasswd/* /swag/nginx/ && echo "Done." || { echo "Error!" && exit 1; }
