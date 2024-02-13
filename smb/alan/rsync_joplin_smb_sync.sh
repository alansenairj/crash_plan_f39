#!/bin/bash

# Define name, source and destination paths
BACKUP_NAME=JOPLIN
SOURCE_DIR="/home/alan"
BACKUP_BASE="/home/alan/tplink-share/critical_settings/joplin"

# log and date part
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")
TIMESTAMP=$(date +"%Y%m%d_%H-%M-%S")

# List of files and folders to backup using tar
FILES_TO_TAR=(
    ".config/Joplin"
    ".config/joplin-desktop"
)

# INTRO OF SCRIPT AND LOG
echo - >>"${LOG}"
echo - >>"${LOG}"
echo "=====================================" >>"${LOG}"
echo "SYNC FROM ${BACKUP_NAME} TO ${BACKUP_BASE} --STARTED-- at ${DATE}" >>"${LOG}"
echo "SYNC FROM ${BACKUP_NAME} TO ${BACKUP_BASE} --STARTED-- at ${DATE}"
echo "--------------------------------------"

# Ensure backup base directory exists
echo "Ensure backup base directory exists" >> "${LOG}"
mkdir -p "${BACKUP_BASE}" >>"${LOG}" 2>&1
echo "--------------------------------------" >>"${LOG}"

# Create a folder with the timestamp
echo "Creating a folder with the timestamp" >>"${LOG}"
BACKUP_FOLDER="${BACKUP_BASE}/backup_${TIMESTAMP}"
# trunk-ignore(shellcheck/SC2129)
mkdir -p "${BACKUP_FOLDER}" >>"${LOG}" 2>&1
echo - >>"${LOG}"
echo - >>"${LOG}"
echo "=====================================" >>"${LOG}"
echo "FOLDER CREATED AT ${DATE}" >>"${LOG}"
echo "--------------------------------------" >>"${LOG}"

# Loop through each file/folder and create a tar archive
echo "Loop through each file/folder and create a tar archive."  >> "${LOG}"
for ITEM in "${FILES_TO_TAR[@]}"; do
    TAR_FILENAME="$(basename "$ITEM")"
    tar czvf "$BACKUP_FOLDER/$TAR_FILENAME.tar.gz" -C "$SOURCE_DIR" "$TAR_FILENAME" 2>&1 >> "${LOG}"
done
echo "... Tarring completed" >> "${LOG}"
echo "SYNC FROM CONSOLE ${BACKUP_NAME} TO ${BACKUP_BASE} has finished at ${DATE}" >> "${LOG}"
echo "--------------------------------------" >> "${LOG}"


## Purge old backups, keeping only the latest two

# Change into the backup directory
cd "${BACKUP_BASE}" || exit
echo " I am at $(pwd) to start to purge old backups" >>"${LOG}" 2>&1

# List all backup folders and sort them based on the timestamp in the folder name
BACKUP_FOLDERS=($(ls -d backup_* | sort -t_ -k2 -n)) >>"${LOG}" 2>&1

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

echo "Last older backups purged at ${DATE}." >>"${LOG}"
echo "--------------------------------------" >>"${LOG}"
echo "Last backup purged."
echo "--------------------------------------"


#FINISHING PART
echo "SYNC FROM CONSOLE $BACKUP_NAME TO ${BACKUP_BASE} --FINISHED-- at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM CONSOLE $BACKUP_NAME TO ${BACKUP_BASE} --FINISHED-- at $DATE"
echo "====================================="