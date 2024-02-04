#!/bin/bash
BACKUP_NAME=MOUSE_SOLAAR
SOURCE="/etc/xdg/autostart/solaar.desktop"
BACKUP_BASE="/home/alan/tplink-share/critical_settings/solaar_mouse"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")
TIMESTAMP=$(date +"%Y%m%d_%H-%M-%S")


# INTRO OF SCRIPT AND LOG
echo - >> "$LOG"
echo - >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM $BACKUP_NAME TO SMB --STARTED-- at $DATE" >> "$LOG"

# Ensure backup base directory exists
echo "Ensure backup base directory exists"  >> "$LOG"
mkdir -p "$BACKUP_BASE" 2>&1 >> "$LOG"
echo "--------------------------------------" >> "$LOG"

# Create a folder with the timestamp
echo " creting a folder with the timestamp" >> "$LOG"
BACKUP_FOLDER="$BACKUP_BASE/backup_$TIMESTAMP"
mkdir -p "$BACKUP_FOLDER" 2>&1 >> "$LOG"
echo - >> "$LOG"
echo - >> "$LOG"
echo "=====================================" >> "$LOG"
echo "FOLDER CREATED AT $DATE" >> "$LOG"
echo "--------------------------------------" >> "$LOG"


echo "=====================================" >> "$LOG"
echo "SYNC FROM FSTAB TO SMB --STARTED-- at $DATE" >> "$LOG"

# Run rsync to synchronize the source to the backup folder
rsync -avz --no-o --no-g --no-perms --progress --stats "$SOURCE" "$BACKUP_FOLDER" 2>&1 >> "$LOG"

## Purge old backups, keeping only the latest two
echo "Purging old backups. Keeping last two"
echo "Purging old backups. Keeping last two" >> "$LOG"
# Define the DIRECTORY where your FOLDERS are located
DIRECTORY="$BACKUP_BASE"
# List FOLDERS based on timestamp
FOLDERS=$(ls -l "$DIRECTORY" | grep '^d' | awk '{print $9}')
# Count the number of FOLDERS
FOLDER_COUNT=$(echo "$FOLDERS" | wc -l)
# Check if there are more than 2 FOLDERS
if [ "$FOLDER_COUNT" -gt 2 ]; then
    # List FOLDERS based on timestamp, skip the first 2 (keep the latest 2), and remove the rest
    FOLDERS_to_remove=$(echo "$FOLDERS" | sort | head -n -2)
    
    # Print the list of FOLDERS that would be removed
    echo "FOLDERS to be removed:" >> "$LOG"
    echo "$FOLDERS_to_remove" >> "$LOG"
    
    # remove the FOLDERS
    echo "$FOLDERS_to_remove" | xargs -I {} rm -r "$DIRECTORY/{}" 2>&1 >> "$LOG"
fi
echo "Last backup purged." >> "$LOG"
echo "--------------------------------------" >> "$LOG"

#FINISHING PART
echo "SYNC FROM $BACKUP_NAME TO SMB --FINISHED-- at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM $BACKUP_NAME TO SMB --FINISHED-- at $DATE"


