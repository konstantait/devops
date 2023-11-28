#!/bin/bash
sudo systemctl daemon-reload
sudo systemctl enable nginx@$1
sudo systemctl start nginx@$1
