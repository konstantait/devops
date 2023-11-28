#!/bin/bash
tee /etc/nginx/sites-available/wordpress.local >/dev/null <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name wordpress.local www.wordpress.local;
        
    location / {
        proxy_pass http://192.168.102.100;
        include proxy_params;
    }
}
EOF

ln -s /etc/nginx/sites-available/wordpress.local /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
systemctl restart nginx