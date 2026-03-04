#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/var/log/roboshop"
LOG_FILE="$LOG_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"
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

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in $G $TOTAL_TIME seconds $N" | tee a $LOG_FILE
}
