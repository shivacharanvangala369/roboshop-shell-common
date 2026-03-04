#!/bin/bash

source ./common.sh

check_root


cp mongo.repo /etc/yum.repos.d/mongo.repo 
VALIDATE  $? "copying mongorepo"


dnf install mongodb-org -y   &>>$LOG_FILE
VALIDATE  $? "Installing mongodb"

systemctl enable mongod      &>>$LOG_FILE
VALIDATE  $? "enable mongodb"

systemctl start mongod      &>>$LOG_FILE
VALIDATE  $? "start mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g"   /etc/mongod.conf  
VALIDATE  $? "Update listen address"

systemctl restart mongod     &>>$LOG_FILE
VALIDATE  $? "restart mongodb"

print_total_time