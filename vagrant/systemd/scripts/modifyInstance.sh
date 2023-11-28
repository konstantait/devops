#!/bin/bash
sudo rm -rf /etc/nginx@$1 || true
sudo cp -rfp /etc/nginx/ /etc/nginx@$1
sudo rm /etc/nginx@$1/sites-enabled/default
sudo ln -s /etc/nginx@$1/sites-available/default /etc/nginx@$1/sites-enabled/default
sudo rm -rf /var/www@$1 || true
sudo cp -rfp /var/www/ /var/www@$1
# ngimx.conf
sudo sed -i "s|nginx.pid|nginx@$1.pid|g" /etc/nginx@$1/nginx.conf
sudo sed -i "s|/etc/nginx|/etc/nginx@$1|g" /etc/nginx@$1/nginx.conf
sudo sed -i "s|/var/log/nginx/access|/var/log/nginx/access@$1|g" /etc/nginx@$1/nginx.conf
sudo sed -i "s|/var/log/nginx/error|/var/log/nginx/error@$1|g" /etc/nginx@$1/nginx.conf
# /sites-available/default
sudo sed -i "s|80 default_server|$1 default_server|g" /etc/nginx@$1/sites-available/default
sudo sed -i "s|/var/www/html|/var/www@$1/html|g" /etc/nginx@$1/sites-available/default
# index.nginx-debian.html
sed -i "s|Welcome to nginx!|Welcome to nginx on port $1!|g" /var/www@$1/html/index.nginx-debian.html



