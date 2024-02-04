#!/bin/bash

# Define source and destination paths
SOURCE_DIR="/home/alan"
BACKUP_BASE="/mnt/sdd1/critical_settings/joplin/"
TEMP_DIR="/tmp/rsync_temp"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")
BACKUP_BASE="/home/alan/tplink-share/console_home_dotfiles"

# List of files and folders to rsync
FILES_TO_RSYNC=(
    ".config/Joplin"
    ".config/joplin-desktop"
)

# Ensure backup base directory exists
mkdir -p "$BACKUP_BASE" 2>&1 >> "$LOG"

echo "=====================================" >> "$LOG"
echo "SYNC FROM SYS JOPLIN TO USB STARTED" >> "$LOG"

# Create temporary directory
echo "Create temporary directory" >> "$LOG"
mkdir -p "$TEMP_DIR"

# Loop through each file/folder, create tar.gz archive, rsync, and remove tar.gz
for ITEM in "${FILES_TO_RSYNC[@]}"; do
    # Create tar.gz archive in the temporary directory
    echo "Create tar.gz archive for $ITEM in the temporary directory" >> "$LOG"
    tar -vczf "$TEMP_DIR/$(basename "$ITEM")-$DATE.tar.gz" -C "$SOURCE_DIR" "$ITEM" >> "$LOG"
    
    # Rsync the tar.gz archive to the destination
    echo "Starting Rsync for $ITEM" >> "$LOG"
    rsync -avz --no-o --no-g --no-perms --progress --stats "$TEMP_DIR/$(basename "$ITEM")-$DATE.tar.gz" "$BACKUP_BASE/"  >> "$LOG"
    
    # Remove the tar.gz archive from the temporary directory
    echo "Remove the tar.gz archive for $ITEM from the temporary directory" >> "$LOG"
    rm "$TEMP_DIR/$(basename "$ITEM")-$DATE.tar.gz"
done

# Remove temporary directory
rmdir "$TEMP_DIR"

echo "... rsync of tar.gz files to USB completed." >> "$LOG"
echo " SYNC FROM SYS JOPLIN TO USB has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
