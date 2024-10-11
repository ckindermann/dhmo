#directory of TSV files
DIRECTORY=$1

#LDTab database
DATABASE="ldtab.db"

TABLE="statement"

#download LDTab
curl -L -o ldtab.jar 'https://github.com/ontodev/ldtab.clj/releases/download/v2023-12-21/ldtab.jar'
java -jar ldtab.jar init $DATABASE
java -jar ldtab.jar prefix $DATABASE prefix.tsv

for FILE in "$DIRECTORY"/*
do
    if [ -f "$FILE" ]; then
        echo "Processing file: $FILE"

        lines=$(wc -l < $FILE)

        for i in $(seq 1 $lines); do echo '1'; done >> assertion.tsv
        for i in $(seq 1 $lines); do echo '0'; done >> retraction.tsv
        for i in $(seq 1 $lines); do echo 'graph'; done >> graph.tsv
        #for i in $(seq 1 $lines); do echo 'NULL'; done >> annotation.tsv

        paste graph.tsv $FILE > 1.tsv
        paste retraction.tsv 1.tsv > 2.tsv
        paste assertion.tsv 2.tsv > output.tsv
        #paste 3.tsv annotation.tsv > output.tsv

        TSV_FILE="output.tsv"

        sqlite3 "$DATABASE" <<EOF
.mode tabs
.import $TSV_FILE $TABLE
EOF

        #clean up
        rm 1.tsv
        rm 2.tsv
        #rm 3.tsv
        rm assertion.tsv
        rm retraction.tsv
        rm graph.tsv
        #rm annotation.tsv
        rm output.tsv
    fi
done

java -jar ldtab.jar export $DATABASE ldtab.ttl
