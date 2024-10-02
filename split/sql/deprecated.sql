-- Enable headers and column mode for better output
-- .headers on
.mode csv
.separator "\t"

-- SQL query to execute
SELECT 
REPLACE(REPLACE("subject", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "subject",
REPLACE(REPLACE("predicate", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "predicate",
REPLACE(REPLACE("object", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "object",
REPLACE(REPLACE("datatype", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "datatype",
REPLACE(REPLACE("annotation", CHAR(13), '<<BR>>'), CHAR(10), '<<BR>>') AS "annotation"
FROM statement
WHERE predicate = 'owl:deprecated'
   OR subject IN (
       SELECT subject
       FROM statement
       WHERE predicate = 'owl:deprecated'
   );