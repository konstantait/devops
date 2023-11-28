#!/bin/bash
mkdir -p /vagrant/sources

cat /lib/systemd/system/nginx.service | egrep -v "^\s*(#|$)" > /vagrant/sources/nginx@.service 
cat /etc/nginx/nginx.conf | egrep -v "^\s*(#|$)" > /vagrant/sources/nginx.conf
cat /etc/nginx/sites-available/default | egrep -v "^\s*(#|$)" > /vagrant/sources/default
cat /var/www/html/index.nginx-debian.html | egrep -v "^\s*(#|$)" > /vagrant/sources/index.nginx-debian.html

