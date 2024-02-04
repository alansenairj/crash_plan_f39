#!/bin/bash

SOURCE="/home/alan/csi_senhas/"
BACKUP_BASE="/mnt/sdd1/keepass/csi/"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")

# Ensure backup base directory exists
mkdir -p "$BACKUP_BASE" 2>&1 >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM CSI KEEPASS DB TO SMB STARTED" >> "$LOG"
rsync -avz --no-o --no-g --no-perms --progress --stats "$SOURCE" "$BACKUP_BASE"  2>&1 >> "$LOG"
echo ... >> "$LOG"
echo " SYNC FROM CSI KEEPASS DB TO SMB has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"