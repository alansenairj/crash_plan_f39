#!/bin/bash

# Define source and destination paths
BACKUP_NAME=USB_TO_SMB_IMG
SOURCE_DIR="/mnt/sdd1/clonezilla_images"
BACKUP_BASE="/home/alan/tplink-share/clonezilla_images"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")
TIMESTAMP=$(date +"%Y%m%d_%H-%M-%S")


# INTRO OF SCRIPT AND LOG
echo - >> "${LOG}"
echo - >> "${LOG}"
echo "=====================================" >> "${LOG}"
echo "SYNC FROM $BACKUP_NAME TO SMB --STARTED-- at ${DATE}" >> "${LOG}"
echo "SYNC FROM $BACKUP_NAME TO SMB --STARTED-- at ${DATE}"
echo "--------------------------------------"

# Ensure backup base directory exists
echo "Ensure backup base directory exists" >>"${LOG}"
mkdir -p "${BACKUP_BASE}" >>"${LOG}" 2>&1
echo "--------------------------------------" >>"${LOG}"

# Create a folder with the timestamp
echo "Creating a folder with the timestamp" >> "${LOG}"
BACKUP_FOLDER="$BACKUP_BASE/backup_$TIMESTAMP"
mkdir -p "${BACKUP_FOLDER}" >> "${LOG}"  2>&1
echo - >> "$LOG"
echo - >> "$LOG"
echo "=====================================" >> "$LOG"
echo "FOLDER CREATED AT $DATE" >> "$LOG"
echo "--------------------------------------" >> "$LOG"

echo "=====================================" >>"${LOG}"
echo "SYNC FROM USB CASE TO NVME CASE STARTED" >>"${LOG}"
#rsync -avz --no-o --no-g --no-perms --progress --stats "${SOURCE_DIR}/" "${BACKUP_FOLDER}/" >>"${LOG}" 2>&1
echo . >>"${LOG}"
echo " SYNC FROM USB CASE TO NVME CASE FINISHED AT ${DATE}" >>"${LOG}"
echo "=====================================" >>"${LOG}"

# Purge old backups, keeping only the latest two
# Change into the backup directory
cd "${BACKUP_BASE}" || exit
echo " I am at $(pwd) to start to purge old backups"  >>"${LOG}" 2>&1

# List all backup folders and sort them based on the timestamp in the folder name
BACKUP_FOLDERS=($(ls -d backup_* | sort -t_ -k2 -n)) >> "${LOG}" 2>&1

# Determine the number of backup folders
NUM_FOLDERS=${#BACKUP_FOLDERS[@]}

# Set the maximum number of folders to keep
MAX_FOLDERS_TO_KEEP=3

# Ensure there are at least two folders before deleting any
if [ "$NUM_FOLDERS" -le "$MAX_FOLDERS_TO_KEEP" ]; then
    echo "Not enough folders to delete. Exiting."
    exit 0
fi

## Calculate the number of folders to delete
FOLDERS_TO_DELETE=$((NUM_FOLDERS - MAX_FOLDERS_TO_KEEP))

# Delete the oldest folders
for ((i = 0; i < FOLDERS_TO_DELETE; i++)); do
    FOLDER_TO_DELETE="${BACKUP_FOLDERS[$i]}"
    echo "Deleting $FOLDER_TO_DELETE" >>"${LOG}"
    rm -r "$FOLDER_TO_DELETE" >>"${LOG}"
done

# trunk-ignore(shellcheck/SC2129)
echo "Last older backups purged at ${DATE}." >>"${LOG}"
echo "--------------------------------------" >>"${LOG}"
echo "Last backup purged."
echo "--------------------------------------"

#FINISHING PART
echo "SYNC FROM $BACKUP_NAME TO SMB --FINISHED-- at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM $BACKUP_NAME TO SMB --FINISHED-- at $DATE"
echo "====================================="