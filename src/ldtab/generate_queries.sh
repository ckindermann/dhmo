#!/bin/bash

# Check if the input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 input_file.txt"
    exit 1
fi

# input file is a list predicates
INPUT_FILE="$1"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "The file '$INPUT_FILE' does not exist."
    exit 1
fi

# Read each RDF predicate from the input file
while IFS= read -r word; do
    # Skip empty lines
    if [ -z "$word" ]; then
        continue
    fi
    # Trim leading and trailing whitespace
    word=$(echo "$word" | xargs)
    # Sanitize the word for use in filenames
    SAFE_WORD=$(echo "$word" | tr -cd '[:alnum:]_-')
    # Define the output file name
    OUTPUT_FILE="${SAFE_WORD}.sql"
    # Write a multiline paragraph to the output file
    cat > "$OUTPUT_FILE" <<EOL
.mode list
.separator "\t"

SELECT
    subject,
    predicate,
    object,
    datatype
FROM statement
WHERE predicate='$word';
EOL
    echo "Created file '$OUTPUT_FILE'."
done < "$INPUT_FILE"
