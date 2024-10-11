#!/bin/bash

RESULTS="./tsv"

# Check if a directory is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 DIRECTORY"
    exit 1
fi

# directory of SQLite3 queries
DIRECTORY="$1"

# Verify that the provided argument is a directory
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: $DIRECTORY is not a directory."
    exit 1
fi

# Iterate over files in the directory
for FILE in "$DIRECTORY"/*
do
    if [ -f "$FILE" ]; then
        echo "Processing file: $FILE"
        # Add your code here to process each file
        BASENAME=$(basename "$FILE")
        FILENAME="${BASENAME%.*}"

        sqlite3 full.db < $FILE > $RESULTS/$FILENAME.tsv

    fi
done
