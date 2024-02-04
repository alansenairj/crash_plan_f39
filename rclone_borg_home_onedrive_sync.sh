#!/bin/bash

LOCAL_RCLONE_REPO="/mnt/sdd1/rclone_csi/"
LOCAL_BORG_REPO="/mnt/sdd1/backup_home/"
RCLONE_REMOTE="csi"
LOG_RCLOUD="/home/alan/logs/rclone.log"
LOG="/var/log/rsync/rsync.log"
DATE==$(date +"%Y-%m-%d_%H:%M:%S")

# Perform rsync from backup_home to rclone_csi
echo "=====================================" >> "$LOG"
echo "SYNC FROM BORG HOME TO RCLONE STARTED" >> "$LOG"
rsync -avz --no-o --no-g --no-perms --progress --stats "$LOCAL_BORG_REPO" "$LOCAL_RCLONE_REPO" 2>&1 >> "$LOG"
echo ... >> "$LOG"
echo " SYNC FROM LOCAL_BORG_REPO TO LOCAL_RCLONE_REP has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"

# Check if rsync was successful before proceeding with rclone
if [ $? -eq 0 ]; then
    # Initiating rclone sync
    while ! rclone -v --checkers=12 --transfers=2 \
                   --multi-thread-cutoff=1k --multi-thread-streams=8 \
                   --low-level-retries=1000 --rc \
                   sync "$LOCAL_BORG_REPO" "$RCLONE_REMOTE:" 2>&1 >> "$LOG_RCLOUD";
    do 
        sleep 60m
        echo "=== $(date)" 2>&1 >> "$LOG_RCLOUD"
    done
else
    echo "rsync failed, skipping rclone sync." 2>&1 >> "$LOG_RCLOUD"
fi
echo ... >> "$LOG"
echo " SYNC FROM LOCAL_RCLONE_REP TO CLOUD has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
