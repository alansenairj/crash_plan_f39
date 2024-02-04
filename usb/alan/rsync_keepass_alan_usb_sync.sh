#!/bin/bash

SOURCE="/home/alan/OneDrive/keepass/"
BACKUP_BASE="/mnt/sdd1/keepass/alan/"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")

# Ensure backup base directory exists
mkdir -p "$BACKUP_BASE" 2>&1 >> "$LOG"

echo "=====================================" >> "$LOG"
echo "SYNC FROM ALAN KEEPASS DB TO USB STARTED" >> "$LOG"
rsync -avz --no-o --no-g --no-perms --progress --stats "$SOURCE" "$BACKUP_BASE"  2>&1 >> "$LOG"
echo ... >> "$LOG"
echo " SYNC FROM ALAN KEEPASS DB TO USB has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
echo " SYNC FROM ALAN KEEPASS DB TO USB has finished at $DATE"