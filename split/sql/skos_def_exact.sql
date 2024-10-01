-- Enable headers and column mode for better output
-- .headers on
-- .mode quote
.mode csv
.separator "\t"

SELECT 
REPLACE(REPLACE("subject", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "subject",
REPLACE(REPLACE("predicate", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "predicate",
REPLACE(REPLACE("object", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "object",
REPLACE(REPLACE("datatype", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "datatype",
REPLACE(REPLACE("annotation", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "annotation"
FROM statement
WHERE subject IN (
    SELECT subject
    FROM statement
    GROUP BY subject
    HAVING COUNT(*) = 6
       AND COUNT(CASE WHEN predicate IN ('rdf:type', 'skos:exactMatch', 'skos:definition', 'skos:prefLabel', 'skos:broader', 'skos:inScheme') THEN 1 END) = 6
);
