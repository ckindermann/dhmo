#!/bin/bash
#DIRECTORY="$1"

DIRECTORY="./templates"
OUTPUT="./value_sets"

ontologies=""

for FILE in "$DIRECTORY"/*
do
    if [ -f "$FILE" ]; then

        echo "Processing file: $FILE"
        BASENAME=$(basename "$FILE")
        FILENAME="${BASENAME%.*}"

        java -jar robot.jar template --template $FILE --prefixes obo_context.jsonld --ontology-iri "$FILENAME.owl" --output $OUTPUT/$FILENAME.owl

        ontologies="${ontologies}--input $OUTPUT/${FILENAME}.owl "
    fi
done

printf "Ontologies: $ontologies\n"

java -jar robot.jar merge $ontologies --output $OUTPUT/merged.owl
