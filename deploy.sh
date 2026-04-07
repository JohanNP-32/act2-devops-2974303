#!/bin/bash

LOG_DEPLOY="./logs/deploy.log"
source config/config.env
mkdir -p logs
echo "$(date) - INFO: Iniciando Orquestación DevOps" | tee -a $LOG_DEPLOY

# Captura de 4 parámetros desde la terminal
ACCION_EC2=$1
INSTANCE_ID=$2
DIR_TO_BACKUP=$3
S3_BUCKET=$4

# Validación de parámetros
if [ -z "$ACCION_EC2" ] || [ -z "$INSTANCE_ID" ] || [ -z "$DIR_TO_BACKUP" ] || [ -z "$S3_BUCKET" ]; then
    echo "$(date) - ERROR: Faltan parámetros." | tee -a $LOG_DEPLOY
    echo "Uso: ./deploy.sh <accion> <instance_id> <directorio> <bucket>"
    exit 1
fi

# 1. Ejecutar Gestión de EC2 (Python)
echo "$(date) - INFO: Ejecutando EC2: $ACCION_EC2 en $INSTANCE_ID" | tee -a $LOG_DEPLOY
python3 ec2/gestionar_ec2.py "$ACCION_EC2" "$INSTANCE_ID"

if [ $? -ne 0 ]; then
    echo "$(date) - ERROR: Falló script EC2" | tee -a $LOG_DEPLOY
    exit 1
fi

# 2. Ejecutar Respaldo en S3 (Bash)
echo "$(date) - INFO: Ejecutando Backup de $DIR_TO_BACKUP en $S3_BUCKET" | tee -a $LOG_DEPLOY
bash s3/backup_s3.sh "$DIR_TO_BACKUP" "$S3_BUCKET"

if [ $? -ne 0 ]; then
    echo "$(date) - ERROR: Falló script S3" | tee -a $LOG_DEPLOY
    exit 1
fi

echo "$(date) - EXITOSO: Despliegue completado." | tee -a $LOG_DEPLOY
