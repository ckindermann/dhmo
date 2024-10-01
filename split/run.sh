#!/bin/bash

RESULTS="./results"

# Check if a directory is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 DIRECTORY"
    exit 1
fi

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
        sort $RESULTS/$FILENAME.tsv > $RESULTS/diff/$FILENAME.tsv

    fi
done

comm -23 $RESULTS/diff/all.tsv $RESULTS/diff/deprecated.tsv > $RESULTS/diff/1.tsv
comm -23 $RESULTS/diff/1.tsv $RESULTS/diff/label_def_type.tsv > $RESULTS/diff/2.tsv
comm -23 $RESULTS/diff/2.tsv $RESULTS/diff/skos_def.tsv > $RESULTS/diff/3.tsv
comm -23 $RESULTS/diff/3.tsv $RESULTS/diff/skos_def_exact.tsv > $RESULTS/diff/4.tsv
comm -23 $RESULTS/diff/4.tsv $RESULTS/diff/skos_def_2_exact.tsv > $RESULTS/diff/5.tsv
comm -23 $RESULTS/diff/5.tsv $RESULTS/diff/fdc_deprecated.tsv > $RESULTS/diff/6.tsv
comm -23 $RESULTS/diff/6.tsv $RESULTS/diff/skos.tsv > $RESULTS/diff/7.tsv
comm -23 $RESULTS/diff/7.tsv $RESULTS/diff/skos.tsv > $RESULTS/diff/8.tsv
comm -23 $RESULTS/diff/8.tsv $RESULTS/diff/license_identifier.tsv > $RESULTS/diff/9.tsv
comm -23 $RESULTS/diff/9.tsv $RESULTS/diff/mimet_type.tsv > $RESULTS/diff/10.tsv
