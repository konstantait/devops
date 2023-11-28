sudo tee /opt/alertTelegramDiskQuota.sh >/dev/null <<EOF
#!/bin/bash
# Tracks disk space and send alert to telegram
# alertTelegramDiskQuota.sh quota api_token chat_id
CURRENT=\$(df / | grep / | tr -s ' ' | cut -d ' ' -f 5 | sed 's/%//g')
if [ "\$CURRENT" -gt "\$1" ] ; then
   curl -s --data "text=Free space is critically low. Used: \$CURRENT" --data "chat_id=\$3" 'https://api.telegram.org/bot'\$2'/sendMessage'
fi
EOF
sudo chmod +x /opt/alertTelegramDiskQuota.sh

sudo tee /etc/systemd/system/alertTelegramDiskQuota.service >/dev/null <<EOF
[Unit]
Description=Tracks disk space and send alert to telegram

[Service]
EnvironmentFile=/vagrant/.env
ExecStart=/bin/bash /opt/alertTelegramDiskQuota.sh \${THRESHOLD} \${API_TOKEN} \${CHAT_ID}

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/alertTelegramDiskQuota.timer >/dev/null <<EOF
[Unit]
Description=Tracks disk space and send alert to telegram
Requires=alertTelegramDiskQuota.service

[Timer]
Unit=alertTelegramDiskQuota.service
OnCalendar=*-*-* 06,14,22:00:00

[Install]
WantedBy=timers.target
EOF

sudo systemctl enable alertTelegramDiskQuota.timer
sudo systemctl daemon-reload
sudo systemctl start alertTelegramDiskQuota.timer