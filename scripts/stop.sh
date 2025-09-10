#!/bin/bash
set -e
install -d -m 0755 /var/www/helloweb
chown ec2-user:ec2-user /var/www/helloweb
systemctl stop helloweb || true
