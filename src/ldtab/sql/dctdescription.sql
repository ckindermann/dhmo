.mode list
.separator "\t"

SELECT
    subject,
    predicate,
    object,
    datatype
FROM statement
WHERE predicate='dct:description';