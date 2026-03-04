#!/bin/bash
source ./common.sh

check_root




dnf module disable redis -y    &>>$LOG_FILE
dnf module enable redis:7 -y   &>>$LOG_FILE
dnf install redis -y           &>>$LOG_FILE
VALIDATE  $? " enable and install redis"


sed -i -e "s/127.0.0.1/0.0.0.0/g" -e "/protected-mode/ c protected-mode no" /etc/redis/redis.conf 
VALIDATE  $? "Allowing remote connection"

systemctl enable redis   &>>$LOG_FILE
systemctl start redis    &>>$LOG_FILE
VALIDATE  $? "enable and start redis"

print_total_time