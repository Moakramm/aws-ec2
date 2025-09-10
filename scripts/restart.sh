#!/bin/bash
set -e

# تأمين المجلد والملكية
install -d -m 0755 /var/www/helloweb
chown -R ec2-user:ec2-user /var/www/helloweb

# لقّط أول DLL منشور (نتيجة dotnet publish)
APP_DLL=$(find /var/www/helloweb -maxdepth 1 -type f -name "*.dll" | head -n1)
if [ -z "$APP_DLL" ]; then
  echo "No published DLL found in /var/www/helloweb"
  exit 1
fi

# اكتب/حدّث خدمة systemd
cat >/etc/systemd/system/helloweb.service <<EOF
[Unit]
Description=ASP.NET Core app
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/var/www/helloweb
ExecStart=/usr/bin/dotnet $APP_DLL
Environment=ASPNETCORE_URLS=http://0.0.0.0:5000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable helloweb
systemctl restart helloweb
systemctl status --no-pager helloweb || true
