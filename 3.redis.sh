#!/bin/bash
source ./0.common.sh

check_root

update_packages

echo "Installing Remi repository..." | tee -a "$LOGFILE"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y >> "$LOGFILE" 2>&1
VALIDATE $? "Installing Remi repository"

echo "Enabling Redis 6.2 module..." | tee -a "$LOGFILE"
dnf module enable redis:remi-6.2 -y >> "$LOGFILE" 2>&1
VALIDATE $? "Enabling Redis 6.2 module"

echo "Installing Redis..." | tee -a "$LOGFILE"
dnf install -y redis >> "$LOGFILE" 2>&1
VALIDATE $? "Installing Redis"

echo "Updating Redis configuration to listen on all IP addresses..." | tee -a "$LOGFILE"
sed -i 's/^bind 127\.0\.0\.1 -::1/bind 0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
VALIDATE $? "Updating Redis configuration"

echo "Enabling Redis service..." | tee -a "$LOGFILE"
systemctl enable redis >> "$LOGFILE" 2>&1
VALIDATE $? "Enabling Redis service"

echo "Starting Redis service..." | tee -a "$LOGFILE"
systemctl start redis >> "$LOGFILE" 2>&1
VALIDATE $? "Starting Redis service"

echo "Redis setup and configuration completed successfully." | tee -a "$LOGFILE"
