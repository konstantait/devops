#!/bin/bash
sudo systemctl status --no-pager nginx* > /vagrant/results
sudo systemctl status --no-pager trackBlacklistedIP.service >> /vagrant/results
sudo systemctl status --no-pager alertTelegramDiskQuota.service >> /vagrant/results

sudo cp -rfp /etc/systemd/system/nginxMemoryLimit.slice /vagrant/sources