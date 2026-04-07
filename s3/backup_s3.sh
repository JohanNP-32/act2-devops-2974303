#!/bin/bash

DIR_TARGET=$1
BUCKET=$2
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ZIP_FILE="backup_$DATE.zip"
LOG_FILE="./logs/backup.log"

if [ -z "$DIR_TARGET" ] || [ -z "$BUCKET" ]; then
    echo "$(date) - ERROR: Faltan parámetros. Uso: $0 <directorio> <bucket>" | tee -a $LOG_FILE
    exit 1
fi

if [ ! -d "$DIR_TARGET" ]; then
    echo "$(date) - ERROR: El directorio $DIR_TARGET no existe." | tee -a $LOG_FILE
    exit 1
fi

echo "$(date) - INFO: Comprimiendo archivos de $DIR_TARGET" | tee -a $LOG_FILE
zip -r $ZIP_FILE $DIR_TARGET

echo "$(date) - INFO: Subiendo $ZIP_FILE a s3://$BUCKET/" | tee -a $LOG_FILE
aws s3 cp $ZIP_FILE s3://$BUCKET/

if [ $? -eq 0 ]; then
    echo "$(date) - EXITOSO: Backup subido a S3." | tee -a $LOG_FILE
    rm $ZIP_FILE
else
    echo "$(date) - ERROR: Falla al subir a S3." | tee -a $LOG_FILE
    exit 1
fi
