#!/bin/bash
# nvme usb is not a good base. it not work 100% well
# Define source and destination paths
BACKUP_NAME=USB_TO_SMB_IMG
SOURCE_DIR="/mnt/sdd1/clonezilla_images"
BACKUP_BASE="/mnt/sdf1"
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

# Rsync part
echo "=====================================" >> "$LOG"
echo "SYNC FROM USB CASE TO NVME CASE STARTED" >> "$LOG"
rsync -avz --no-o --no-g --no-perms --progress --stats "$SOURCE_DIR" "$BACKUP_FOLDER" >> "$LOG" 2>&1
echo ... >> "$LOG"
echo " SYNC FROM USB CASE TO NVME CASE FINISHED AT $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"

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