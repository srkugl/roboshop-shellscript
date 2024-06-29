#!/bin/bash

source ./0.common.sh

check_root

update_packages

echo "Configuring Erlang YUM repository..." | tee -a "$LOGFILE"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash >> "$LOGFILE" 2>&1
VALIDATE $? "Configuring Erlang YUM repository"

echo "Configuring RabbitMQ YUM repository..." | tee -a "$LOGFILE"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash >> "$LOGFILE" 2>&1
VALIDATE $? "Configuring RabbitMQ YUM repository"

echo "Installing RabbitMQ..." | tee -a "$LOGFILE"
dnf install rabbitmq-server -y >> "$LOGFILE" 2>&1
VALIDATE $? "Installing RabbitMQ"

echo "Enabling RabbitMQ service..." | tee -a "$LOGFILE"
systemctl enable rabbitmq-server >> "$LOGFILE" 2>&1
VALIDATE $? "Enabling RabbitMQ service"

echo "Starting RabbitMQ service..." | tee -a "$LOGFILE"
systemctl start rabbitmq-server >> "$LOGFILE" 2>&1
VALIDATE $? "Starting RabbitMQ service"

echo "Creating RabbitMQ user..." | tee -a "$LOGFILE"
rabbitmqctl add_user roboshop roboshop123 >> "$LOGFILE" 2>&1
VALIDATE $? "Creating RabbitMQ user"

echo "Setting permissions for RabbitMQ user..." | tee -a "$LOGFILE"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" >> "$LOGFILE" 2>&1
VALIDATE $? "Setting permissions for RabbitMQ user"

echo "RabbitMQ setup and configuration completed successfully." | tee -a "$LOGFILE"
