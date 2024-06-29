#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename $0 | cut -d "." -f1)
LOGFILE="/tmp/$SCRIPT_NAME-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2...$R FAILURE $N" | tee -a "$LOGFILE"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N" | tee -a "$LOGFILE"
    fi
}

check_root(){
    if [ $USERID -ne 0 ]; then
        echo "Please run this script with root access." | tee -a "$LOGFILE"
        exit 1
    fi
}

update_packages(){
    echo "Updating Packages..." | tee -a "$LOGFILE"
    dnf update -y >> "$LOGFILE" 2>&1
    VALIDATE $? "Updating Packages"
}