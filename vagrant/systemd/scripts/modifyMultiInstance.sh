#!/bin/bash
cp -rfp /lib/systemd/system/nginx.service /etc/systemd/system/nginx@.service
sed -i "s|nginx.pid|nginx@%i.pid|g" /etc/systemd/system/nginx@.service
sed -i "s|master_process on;'|master_process on;' -c /etc/nginx@%i/nginx.conf|g" /etc/systemd/system/nginx@.service
sed -i "s|proxy server|proxy server on port %i|g" /etc/systemd/system/nginx@.service
sed -i -e "/Service/aPrivateTmp=true" /etc/systemd/system/nginx@.service
sed -i -e "/Service/aSlice=nginxMemoryLimit.slice" /etc/systemd/system/nginx@.service

tee /etc/systemd/system/nginxMemoryLimit.slice >/dev/null <<EOF
[Unit]
Description=Slice that limits memory for nginx services

[Slice]
MemoryMax=50M
EOF
