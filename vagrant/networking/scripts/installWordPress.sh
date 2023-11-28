#!/bin/bash
mkdir -p /app
chown www-data: /app
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /app