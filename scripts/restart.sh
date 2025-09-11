#!/bin/bash
set -e

# تأمين المجلد والملكية
install -d -m 0755 /var/app/current/
chown -R ec2-user:ec2-user /var/app/current/

# لقّط أول DLL منشور (نتيجة dotnet publish)
APP_DLL=$(find /var/app/current/ -maxdepth 1 -type f -name "*.dll" | head -n1)
if [ -z "$APP_DLL" ]; then
  echo "No published DLL found in /var/app/current/"
  exit 1
fi

# اكتب/حدّث خدمة systemd
cat >/etc/systemd/system/current.service <<EOF
[Unit]
Description=ASP.NET Core app
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/var/app/current/
ExecStart=/usr/bin/dotnet $APP_DLL
Environment=ASPNETCORE_URLS=http://0.0.0.0:5000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable current
systemctl restart current
systemctl status --no-pager current || true
