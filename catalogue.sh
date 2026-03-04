#!/bin/bash

source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup

### Loading data into MongoDB####

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo  
VALIDATE  $? "copying mongorepo"



dnf install mongodb-mongosh -y    &>>$LOG_FILE
VALIDATE  $? "installing mogo-client"


INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexO1oOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "Loading products"
else
    echo -e " $(date "+%Y-%m-%d %H:%M:%S") | Products already loaded ... $Y SKIPPING $N"
fi


app_restart
print_total_time