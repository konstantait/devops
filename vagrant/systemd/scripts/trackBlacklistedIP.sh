sudo tee /opt/trackLogfileKeyword.sh >/dev/null <<EOF
#!/bin/bash
# Tracks the keyword in the file
tail -fn0 \$1 | while read line ; do
   echo "\${line}" | grep -i "\$2" > /dev/null
   if [ \$? = 0 ] ; then
      echo "\${line}"
   fi
done
EOF
sudo chmod +x /opt/trackLogfileKeyword.sh

sudo tee /etc/systemd/system/trackBlacklistedIP.service >/dev/null <<EOF
[Unit]
Description=Tracks blacklisted ip in nginx access.log file

[Service]
EnvironmentFile=/vagrant/.env
ExecStart=/bin/bash /opt/trackLogfileKeyword.sh \${KEYWORD_FILE} \${KEYWORD}

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/trackBlacklistedIP.timer >/dev/null <<EOF
[Unit]
Description=Tracks blacklisted ip in nginx access.log file
Requires=trackBlacklistedIP.service

[Timer]
# Run every 30 sec after start service
# OnUnitActiveSec=30
Unit=trackBlacklistedIP.service
# [DOW] YYYY-MM-DD HH:MM:SS
# *-*-* *:*:00 every minute
# Mon..Fri 22:30
# Sat,Sun 20:00
# systemd-analyze calendar --iterations=10 "*-*-* *:*:00,30"
# every 30 sec, i.e. run on the first (00) and 30th second of every minute
OnCalendar=*-*-* *:*:00,30

[Install]
WantedBy=timers.target
EOF

sudo systemctl enable trackBlacklistedIP.timer
sudo systemctl daemon-reload
sudo systemctl start trackBlacklistedIP.timer
