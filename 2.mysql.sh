#!/bin/bash

source ./0.common.sh

check_root

update_packages

echo "Disabling MySQL 8 module..." | tee -a "$LOGFILE"
dnf module disable mysql -y >> "$LOGFILE" 2>&1
VALIDATE $? "Disabling MySQL 8 module"

echo "Creating MySQL 5.7 repo file..." | tee -a "$LOGFILE"
cat <<EOL > /etc/yum.repos.d/mysql.repo
[mysql]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/\$basearch/
enabled=1
gpgcheck=0
EOL
VALIDATE $? "Creating MySQL 5.7 repo file"

echo "Installing MySQL server..." | tee -a "$LOGFILE"
dnf install -y mysql-community-server >> "$LOGFILE" 2>&1
VALIDATE $? "Installing MySQL server"

echo "Enabling MySQL service..." | tee -a "$LOGFILE"
systemctl enable mysqld >> "$LOGFILE" 2>&1
VALIDATE $? "Enabling MySQL service"

echo "Starting MySQL service..." | tee -a "$LOGFILE"
systemctl start mysqld >> "$LOGFILE" 2>&1
VALIDATE $? "Starting MySQL service"

ROOT_PASSWORD="RoboShop@1"

mysql -uroot -p$ROOT_PASSWORD -e "exit" >> "$LOGFILE" 2>&1
if [ $? -ne 0 ]; then
    echo "Securing MySQL installation and setting root password..." | tee -a "$LOGFILE"
    mysql_secure_installation --set-root-pass $ROOT_PASSWORD >> "$LOGFILE" 2>&1
    VALIDATE $? "Securing MySQL installation and setting root password"
else
    echo "Root password is already set." | tee -a "$LOGFILE"
fi

echo "Verifying the root password..." | tee -a "$LOGFILE"
mysql -uroot -p$ROOT_PASSWORD -e "exit" >> "$LOGFILE" 2>&1
VALIDATE $? "Verifying the root password"

echo "MySQL setup and configuration completed successfully." | tee -a "$LOGFILE"
