#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/var/log/roboshop"
LOG_FILE="$LOG_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"
SCRIPT_DIR=PWD
MONGODB_HOST=mongodb.devcops.online
START_TIME=$(date +%s)

mkdir -p $LOG_FOLDER

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at : $(date)" | tee -a $LOG_FILE


check_root() {
    if [ $USERID -ne 0 ]; then
        echo -e "$R please run this script using root user" | tee -a $LOG_FILE
        exit 1
    fi
}


VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2... $R FAILURE" | tee -a $LOG_FILE
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") |$2... $G SUCCESS" | tee -a $LOG_FILE
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y  &>>$LOG_FILE
    VALIDATE  $? "module disable nodejs"

    dnf module enable nodejs:20 -y   &>>$LOG_FILE
    VALIDATE  $? "module enable nodejs"


    dnf install nodejs -y    &>>$LOG_FILE
    VALIDATE  $? "install nodejs"

    cd /app           &>>$LOG_FILE
    npm install      &>>$LOG_FILE
    VALIDATE  $? "installing dependencies"
 
}

app_setup(){
    id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin  --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "Adding roboshop as system user"
    else
        echo -e "Roboshop user alraedy exist...$Y SKIPPLNG $N"
    fi

    mkdir -p /app  &>>$LOG_FILE
    VALIDATE  $? "creating app dir in / "


    curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip   &>>$LOG_FILE
    VALIDATE  $? "downloading $app_name source code"

    cd /app  &>>$LOG_FILE

    rm -rf /app/*   &>>$LOG_FILE
    VALIDATE  $? "removeing app dir in /"

    unzip /tmp/catalogue.zip    &>>$LOG_FILE
    VALIDATE  $? "unzipping $app_name source code"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service 
    VALIDATE  $? "copying $app_name service"

    systemctl daemon-reload    &>>$LOG_FILE
    VALIDATE  $? "daemon-reload"

    systemctl enable $app_name    &>>$LOG_FILE
    systemctl start $app_name     &>>$LOG_FILE
    VALIDATE  $? "enable and starting $app_name services"
}

app_restart(){
    systemctl restart $app_name     &>>$LOG_FILE
    VALIDATE  $? "restarting $app_name services"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in $G $TOTAL_TIME seconds $N" | tee a $LOG_FILE
}
