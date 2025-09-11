#!/bin/bash
set -e
install -d -m 0755 /var/app/current/
chown ec2-user:ec2-user /var/app/current/
systemctl stop helloweb || true
