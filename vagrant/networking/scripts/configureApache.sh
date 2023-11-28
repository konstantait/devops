#!/bin/bash
tee /etc/apache2/sites-available/wordpress.conf >/dev/null <<EOF
<VirtualHost 192.168.102.100:80>
    DocumentRoot /app/wordpress
    <Directory /app/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /app/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2ensite wordpress
a2enmod rewrite
a2dissite 000-default
service apache2 reload