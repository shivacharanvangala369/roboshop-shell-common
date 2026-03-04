#!/bin/bash

source ./common.sh 
check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo   &>>$LOG_FILE
VALIDATE  $? "copying service files"

dnf install rabbitmq-server -y  &>>$LOG_FILE
VALIDATE  $? "install rabbitmq"


systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE  $? "enable and start server"


rabbitmqctl add_user roboshop roboshop123    &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"     &>>$LOG_FILE
VALIDATE  $? "add and set permissions"
