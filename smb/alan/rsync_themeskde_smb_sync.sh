#!/bin/bash
#KONSAVE COMMAND NOT BEING ENCAPSULATED - MUST RUN MANUALLY
# Define name, source and destination paths
SOURCE="/home/alan/themes/konsave"
BACKUP_BASE="/mnt/tplink-share/themes/konsave"

# log and date part
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")
TIMESTAMP=$(date +"%Y%m%d_%H-%M-%S")

# Create timestamped backup folder
BACKUP_DIR="$BACKUP_BASE/backup_$TIMESTAMP"
KONSAVE="/home/alan/.local/bin/konsave"
OPTIONS1="-s f39plasma -f"
OPTIONS2="-e f39plasma -f -d /home/alan/themes/konsave/ -n f39plasma"


# INTRO OF SCRIPT AND LOG
echo - >> "${LOG}"
echo - >> "${LOG}"
echo "=====================================" >> "${LOG}"
echo "SYNC FROM ${BACKUP_NAME} TO ${BACKUP_BASE} --STARTED-- at ${DATE}" >> "${LOG}"
echo "SYNC FROM ${BACKUP_NAME} TO ${BACKUP_BASE} --STARTED-- at ${DATE}"
echo "--------------------------------------"

# Ensure backup base directory exists
echo "Ensure backup base directory exists" >>"${LOG}"
mkdir -p "${BACKUP_BASE}" >>"${LOG}" 2>&1
echo "--------------------------------------" >>"${LOG}"

# clean source for last 2 backups
echo "clean source for last 2 backups"
echo "clean source for last 2 backups" >> "$LOG"
ls -1 -t "$SOURCE" | head -n -2 | xargs -I {} rm -r "$SOURCE/{}" 2>&1 >> "$LOG"

# save a profile and create a backup theme settings file
echo "=====================================" >> "$LOG"
echo "EXPORTING theme settings TO A FILE AT $HOME/konsave at $DATE" >> "$LOG" 
echo "EXPORTING theme settings TO A FILE AT $HOME/konsave at $DATE"
echo "TIP: to import: /home/alan/.local/bin/konsave --import-profile <path>" >> "$LOG"
echo profile theme settings still working  AT $DATE >> "$LOG"
echo profile theme settings still working  AT $DATE
echo  konsave profile theme and settings still working. Wait a few moment. It is $DATE  >> "$LOG"
echo "=====================================" >> "$LOG"

# Execute the command and capture the output
output1=$("$KONSAVE" "$OPTIONS1" 2>&1)
output2=$("$KONSAVE" "$OPTIONS2" 2>&1)

# Check the exit status
exit_status=$?

# Log the output
echo "$output1" >> "$LOG"
echo "$output2" >> "$LOG"

# Check if the command was successful
if [ $exit_status -eq 0 ]; then
    echo "konsave started successfully." >> "$LOG"
else
    echo "Error: konsave failed with exit status $exit_status." >> "$LOG"
fi

echo "=====================================" >> "$LOG"
echo "sync backup theme settings started at $DATE" >> "$LOG"#


# Run rsync to synchronize the source to the backup folder
echo "=====================================" >>"${LOG}"
echo "SYNC FROM ${BACKUP_NAME} TO ${BACKUP_BASE} STARTED" >>"${LOG}"
rsync -avz --no-o --no-g --no-perms --progress --stats "$SOURCE/" "$BACKUP_DIR" 2>&1 >> "$LOG"
echo . >>"${LOG}"
echo " SYNC FROM $BACKUP_NAME TO $BACKUP_BASE FINISHED AT ${DATE}" >>"${LOG}"
echo "=====================================" >>"${LOG}"


## Purge old backups, keeping only the latest two
ls -1 -t "$BACKUP_BASE" | head -n -2 | xargs -I {} rm -r "$BACKUP_BASE/{}" 2>&1 >> "$LOG"
echo "Last backup purged. Left 2: lastest and oldest" >> "$LOG"
echo "backup theme settings has finished at $DATE" >> "$LOG"
echo "=====================================" >> "$LOG"
echo "SYNC FROM backup theme settings TO SMB has finished at $DATE" >> "$LOG"
echo "SYNC FROM backup theme settings TO SMB has finished at $DATE"
