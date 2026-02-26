#!/bin/bash

# -----------------------------
# NetMaze File Validation Script
# -----------------------------

SRC="/home/nfs_ingest"
VALID="/home/validated"
QUAR="/home/quarantine"
LOG="/home/logs/validation.log"

ALLOWED_EXT="txt csv json"
MAX_SIZE=5242880   # 5MB in bytes

# Create required directories if not present
mkdir -p "$VALID"
mkdir -p "$QUAR"
mkdir -p "$(dirname "$LOG")"

echo "-----------------------------" >> "$LOG"
echo "$(date) | Validation Job Started" >> "$LOG"

# Process each file
for file in "$SRC"/*; do
    [ -e "$file" ] || continue

    fname=$(basename "$file")
    ext="${fname##*.}"
    size=$(stat -c%s "$file")

    echo "$(date) | Checking file: $fname" >> "$LOG"

    # 1️⃣ Check if file is empty
    if [ "$size" -eq 0 ]; then
        echo "$(date) | ERROR: $fname is empty → Moving to quarantine" >> "$LOG"
        mv "$file" "$QUAR/"
        continue
    fi

    # 2️⃣ Check file extension
    if [[ ! " $ALLOWED_EXT " =~ " $ext " ]]; then
        echo "$(date) | ERROR: Invalid extension ($ext) → Moving to quarantine" >> "$LOG"
        mv "$file" "$QUAR/"
        continue
    fi

    # 3️⃣ Check file size
    if [ "$size" -gt "$MAX_SIZE" ]; then
        echo "$(date) | ERROR: File too large ($size bytes) → Moving to quarantine" >> "$LOG"
        mv "$file" "$QUAR/"
        continue
    fi

    # 4️⃣ If all validations pass
    echo "$(date) | SUCCESS: $fname validated → Moving to validated folder" >> "$LOG"
    mv "$file" "$VALID/"

done

echo "$(date) | Validation Job Completed" >> "$LOG"
echo "-----------------------------" >> "$LOG"
