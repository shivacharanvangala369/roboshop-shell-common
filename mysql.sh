#!/bin/bash

source ./common.sh 



dnf install mysql-server -y    &>>$LOG_FILE
VALIDATE  $? "install mysql"


systemctl enable mysqld        &>>$LOG_FILE
systemctl start mysqld         &>>$LOG_FILE

VALIDATE  $? "enable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 



