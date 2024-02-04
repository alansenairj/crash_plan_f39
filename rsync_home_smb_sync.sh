#!/bin/bash

SOURCE="/mnt/sdd1/backup_home/"
DEST="/home/alan/tplink-share/home/"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")

# Function to check if Borg is running
function is_borg_running() {
    pgrep -f "borg" >/dev/null
}

while true; do
    # Check if Borg is running
    if is_borg_running; then
        echo "Borg is currently running. Sleeping for 60 minutes before retrying."
        sleep 60m
    fi
echo "=====================================" >> "$LOG"
echo "SYNC FROM SECOND HOME BACKUP TO SMB STARTED" >> "$LOG"
    # Run rsync command
    rsync -avz --no-o --no-g --no-perms --progress --stats "$SOURCE" "$DEST" 2>&1 >> "$LOG"

    # Sleep for 60 minutes before the next iteration
    sleep 60m
done
echo ... >> "$LOG"
echo " SYNC FROM SECOND HOME BACKUP TO SMB has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"