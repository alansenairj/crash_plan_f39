#!/bin/bash
SCRIPTS_FOLDER="/home/alan/scripts/usb/alan"
LOG="/var/log/rsync/rsync.log"
DATE=$(date +"%Y-%m-%d_%H:%M:%S")

# Check if the folder exists
if [ -d "$SCRIPTS_FOLDER" ]; then
    # Loop through each script in the folder
    for script in "$SCRIPTS_FOLDER"/*.sh; do
        # Check if the file is a regular file and executable
        if [ -f "$script" ] && [ -x "$script" ]; then
            # Print the script name before executing
            echo "=====================================" >> "$LOG"
            echo "Executing $script at $DATE" >> "$LOG"
            echo "Executing $script at $DATE"
            # Execute the script
            "$script"
            
            # Sleep for 5 seconds
            echo "sleep for 5 seconds"
            echo "====================================="
            echo "sleep for 5 seconds" >> "$LOG"
            echo "=====================================" >> "$LOG"
            sleep 5
        fi
    done
else
    echo "Scripts folder not found: $SCRIPTS_FOLDER"
    echo "Scripts folder not found: $SCRIPTS_FOLDER" >> "$LOG"
fi
