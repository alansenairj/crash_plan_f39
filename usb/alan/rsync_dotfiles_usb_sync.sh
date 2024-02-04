#!/bin/bash

# Define source and destination paths
SOURCE_DIR="/home/alan"
BACKUP_BASE="/mnt/sdd1/console_home_dotfiles"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")
TIMESTAMP=$(date +"%Y%m%d_%H-%M-%S")

echo "=====================================" >> "$LOG"
echo "SYNC FROM CONSOLE DOTFILES TO USB STARTED AT $DATE" 
echo "SYNC FROM CONSOLE DOTFILES TO USB STARTED AT $DATE" >> "$LOG"
# List of files and folders to rsync
FILES_TO_RSYNC=(
    "$SOURCE_DIR/.oh-my-zsh"
    "$SOURCE_DIR/.bash_history"
    "$SOURCE_DIR/.bashrc"
    "$SOURCE_DIR/.p10k.zsh"
    "$SOURCE_DIR/.zsh_history"
    "$SOURCE_DIR/.zshrc"
)

# Ensure backup base directory exists
mkdir -p "$BACKUP_BASE" 2>&1 >> "$LOG"

# Loop through each file/folder and rsync
for ITEM in "${FILES_TO_RSYNC[@]}"; do
    rsync -avz --no-o --no-g --no-perms --progress --stats "$ITEM" "$BACKUP_BASE/backup_$TIMESTAMP" 2>&1 >> "$LOG"
done
echo ... >> "$LOG"
echo " SYNC FROM CONSOLE DOTFILES TO USB has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"

# Purge old backups, keeping only the latest two
ls -1 -t "$BACKUP_BASE" | head -n -2 | xargs -I {} rm -r "$BACKUP_BASE/{}" 2>&1 >> "$LOG"
echo "Last backup purged." >> "$LOG"
echo "SYNC FROM CONSOLE DOTFILES TO USB --FINISHED-- at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM CONSOLE DOTFILES TO USB --FINISHED-- at $DATE"
echo "====================================="