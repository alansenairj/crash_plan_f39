#!/bin/bash
BACKUP_NAME=DOTFILES
# Define source and destination paths
SOURCE_DIR="/home/alan"
BACKUP_BASE="/home/alan/tplink-share/console_home_dotfiles"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")
TIMESTAMP=$(date +"%Y%m%d_%H-%M-%S")

# List of files and FOLDERS to backup using tar
FILES_TO_TAR=(
    "$SOURCE_DIR/.oh-my-zsh"
    "$SOURCE_DIR/.bash_history"
    "$SOURCE_DIR/.bashrc"
    "$SOURCE_DIR/.p10k.zsh"
    "$SOURCE_DIR/.zsh_history"
    "$SOURCE_DIR/.zshrc"
)

# INTRO OF SCRIPT AND LOG
echo "=====================================" >> "{LOG}"
echo "SYNC FROM SYS $BACKUP_NAME TO SMB STARTED" >> "{LOG}"

# Ensure backup base directory exists
echo "Ensure backup base directory exists"  >> "{LOG}"
mkdir -p "$BACKUP_BASE" 2>&1 >> "{LOG}"
echo "--------------------------------------" >> "{LOG}"

# Create a folder with the timestamp
BACKUP_FOLDER="$BACKUP_BASE/backup_$TIMESTAMP"
mkdir -p "$BACKUP_FOLDER" 2>&1 >> "{LOG}"
echo - >> "{LOG}"
echo - >> "{LOG}"
echo "=====================================" >> "{LOG}"
echo "SYNC FROM CONSOLE $BACKUP_NAME TO SMB STARTED AT $DATE" >> "${LOG}"
echo "SYNC FROM CONSOLE $BACKUP_NAME TO SMB STARTED AT $DATE"
echo "--------------------------------------" >> "{LOG}"


# Loop through each file/folder and create a tar archive
echo "Loop through each file/folder and create a tar archive."  >> "{LOG}"
for ITEM in "${FILES_TO_TAR[@]}"; do
    TAR_FILENAME="$(basename "$ITEM")"
    tar czvf "$BACKUP_FOLDER/$TAR_FILENAME.tar.gz" -C "$SOURCE_DIR" "$TAR_FILENAME" 2>&1 >> "{LOG}"
done

echo "... Tarring completed" >> "{LOG}"
echo "SYNC FROM CONSOLE $BACKUP_NAME TO SMB has finished at $DATE" >> "{LOG}"
echo "--------------------------------------" >> "${LOG}"

## Purge old backups, keeping only the latest two

echo "Purging old backups. Keeping last two"
echo "Purging old backups. Keeping last two" >> "{LOG}"
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
    echo "FOLDERS to be removed:" >> "{LOG}"
    echo "$FOLDERS_to_remove" >> "{LOG}"
    
    # remove the FOLDERS
    echo "$FOLDERS_to_remove" | xargs -I {} rm -r "$DIRECTORY/{}" 2>&1 >> "{LOG}"
fi

#FINISH PART
echo "Last backup purged." >> "{LOG}"
echo "SYNC FROM CONSOLE $BACKUP_NAME TO SMB --FINISHED-- at $DATE" >> "{LOG}"
echo "=====================================" >> "{LOG}"
echo "SYNC FROM CONSOLE $BACKUP_NAME TO SMB --FINISHED-- at $DATE"
echo "====================================="