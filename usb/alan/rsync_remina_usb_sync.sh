#!/bin/bash

SOURCE="/home/alan/.var/app/org.remmina.Remmina/data/remmina/"
BACKUP_BASE="/mnt/sdd1/critical_settings/remina/"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")


# Ensure backup base directory exists
mkdir -p "$BACKUP_BASE" 2>&1 >> "$LOG"

# Create timestamped backup folder
TIMESTAMP=$(date +"%Y%m%d_%H-%M-%S")
BACKUP_DIR="$BACKUP_BASE/backup_$TIMESTAMP"

echo "=====================================" >> "$LOG"
echo "SYNC FROM REMINA CONECTIONS TO USB --STARTED-- at $DATE" >> "$LOG"

# Run rsync to synchronize the source to the backup folder
rsync -avz --no-o --no-g --no-perms --progress --stats "$SOURCE/" "$BACKUP_DIR" 2>&1 >> "$LOG"

# Purge old backups, keeping only the latest two
ls -1 -t "$BACKUP_BASE" | head -n -2 | xargs -I {} rm -r "$BACKUP_BASE/{}" 2>&1 >> "$LOG"
echo "Last backup purged." >> "$LOG"
echo "SYNC FROM REMINA CONECTIONS TO USB --FINISHED-- at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM REMINA CONECTIONS TO USB --FINISHED-- at $DATE"