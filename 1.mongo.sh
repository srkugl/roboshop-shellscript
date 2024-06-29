#!/bin/bash

source ./0.common.sh
check_root
update_packages


MONGO_VERSION="4.2"


echo "Creating MongoDB repo file..." | tee -a "$LOGFILE"
cat <<EOL > /etc/yum.repos.d/mongo.repo
[mongodb-org-$MONGO_VERSION]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/$MONGO_VERSION/x86_64/
gpgcheck=0
enabled=1
EOL
VALIDATE $? "Creating MongoDB repo file"


echo "Installing MongoDB..." | tee -a "$LOGFILE"
dnf install -y mongodb-org >> "$LOGFILE" 2>&1
VALIDATE $? "Installing MongoDB"


echo "Enabling and starting MongoDB service..." | tee -a "$LOGFILE"
systemctl enable mongod >> "$LOGFILE" 2>&1
VALIDATE $? "Enabling MongoDB service"
systemctl start mongod >> "$LOGFILE" 2>&1
VALIDATE $? "Starting MongoDB service"


echo "Updating MongoDB configuration to listen on all IP addresses..." | tee -a "$LOGFILE"
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
VALIDATE $? "Updating MongoDB configuration"


echo "Restarting MongoDB service..." | tee -a "$LOGFILE"
systemctl restart mongod >> "$LOGFILE" 2>&1
VALIDATE $? "Restarting MongoDB service"

echo "MongoDB setup and configuration completed successfully." | tee -a "$LOGFILE"
