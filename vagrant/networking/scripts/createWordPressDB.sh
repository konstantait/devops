#!/bin/bash
mysql -u root <<SCRIPT
CREATE DATABASE wordpress;
CREATE USER wordpress IDENTIFIED BY 'wordpress';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpress;
FLUSH PRIVILEGES;
SCRIPT

sed -i 's/127.0.0.1/192.168.101.100/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql