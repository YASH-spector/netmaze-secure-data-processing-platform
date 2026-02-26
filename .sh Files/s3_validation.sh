#!/bin/bash

# ---------------------------------
# NetMaze S3 Upload Script
# ---------------------------------

SRC="/home/validated"
BUCKET="s3://s3-validated-files7845"   # 🔹 Replace with your actual bucket
ARCHIVE="/home/validated_archived"
LOG="/home/logs/s3_upload.log"

# Create required directories
mkdir -p "$ARCHIVE"
mkdir -p "$(dirname "$LOG")"

echo "---------------------------------" >> "$LOG"
echo "$(date) | S3 Upload Job Started" >> "$LOG"

# Check if source folder has files
if [ -z "$(ls -A $SRC 2>/dev/null)" ]; then
    echo "$(date) | No files to upload." >> "$LOG"
    exit 0
fi

# Sync files to S3
aws s3 sync "$SRC" "$BUCKET" >> "$LOG" 2>&1

# Check if sync was successful
if [ $? -eq 0 ]; then
    echo "$(date) | Files uploaded successfully to $BUCKET" >> "$LOG"

    # Move uploaded files to archive
    for file in "$SRC"/*; do
        [ -e "$file" ] || continue
        mv "$file" "$ARCHIVE/"
        echo "$(date) | Archived: $(basename "$file")" >> "$LOG"
    done

else
    echo "$(date) | ERROR: S3 upload failed!" >> "$LOG"
    exit 1
fi

echo "$(date) | S3 Upload Job Completed" >> "$LOG"
echo "---------------------------------" >> "$LOG"
