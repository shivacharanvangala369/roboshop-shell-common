#!/bin/bash
source ./common.sh 
check_root

dnf module disable nginx -y       &>>$LOG_FILE
dnf module enable nginx:1.24 -y    &>>$LOG_FILE
dnf install nginx -y                &>>$LOG_FILE
VALIDATE  $? "enableing nginx 1.24 and insatlling"

systemctl enable nginx           &>>$LOG_FILE
systemctl start nginx             &>>$LOG_FILE
VALIDATE  $? "enable and start nginx"

rm -rf /usr/share/nginx/html/*        
VALIDATE  $? "removing content in html"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip    &>>$LOG_FILE
VALIDATE  $? "downloading frontend code"


cd /usr/share/nginx/html    &>>$LOG_FILE
unzip /tmp/frontend.zip      &>>$LOG_FILE
VALIDATE  $? "unzipping frontend"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf      
VALIDATE  $? "copying conf file"



app_restart
print_total_time