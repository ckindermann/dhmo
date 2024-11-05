#!/bin/bash

# Check if exactly two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <string> <folder>"
    exit 1
fi

STRING="$1"
FOLDER="$2"

# Check if the folder exists and is a directory
if [ ! -d "$FOLDER" ]; then
    echo "Error: '$FOLDER' is not a valid directory."
    exit 1
fi

# Iterate over all regular files in the folder and its subfolders
find "$FOLDER" -type f -print0 | while IFS= read -r -d '' FILE; do
    # Create a temporary file in the same directory to store the modified content
    TMPFILE="${FILE}.tmp"

    # Remove lines containing the input string and handle errors
    if ! grep -F -v "$STRING" "$FILE" > "$TMPFILE"; then
        echo "Error processing file '$FILE'. Skipping..."
        rm -f "$TMPFILE"
        continue
    fi

    # Overwrite the original file with the temporary file
    if ! mv "$TMPFILE" "$FILE"; then
        echo "Error overwriting file '$FILE'. Skipping..."
        rm -f "$TMPFILE"
        continue
    fi
done
