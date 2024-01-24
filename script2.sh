#!/bin/bash

# Define variables
source_directory="/home"                  # Source directory to be backed up
backup_directory="/path/to/backup"        # Destination directory for backups
date_format=$(date +"%Y%m%d_%H%M%S")     # Timestamp format for backup folder

# Create backup directory if it doesn't exist
mkdir -p "$backup_directory"

# Create a new backup folder with timestamp
backup_folder="$backup_directory/backup_$date_format"
mkdir "$backup_folder"

# Perform the backup using rsync
rsync -av --delete "$source_directory/" "$backup_folder/"

# Display completion message
echo "Backup completed successfully. Files are stored in: $backup_folder"
