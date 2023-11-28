#!/bin/bash
sudo -u www-data cp /app/wordpress/wp-config-sample.php /app/wordpress/wp-config.php
sed -i 's/database_name_here/wordpress/' /app/wordpress/wp-config.php
sed -i 's/username_here/wordpress/' /app/wordpress/wp-config.php
sed -i 's/password_here/wordpress/' /app/wordpress/wp-config.php
sed -i 's/localhost/192.168.101.100/' /app/wordpress/wp-config.php