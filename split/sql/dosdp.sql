.mode list
.separator "\t"

SELECT
    subject,
    MAX(CASE WHEN predicate = 'rdf:type' THEN formatted_object END) AS rdf_type,
    MAX(CASE WHEN predicate = 'rdfs:label' THEN formatted_object END) AS rdfs_label,
    MAX(CASE WHEN predicate = 'skos:prefLabel' THEN formatted_object END) AS skos_prefLabel,
    MAX(CASE WHEN predicate = 'skos:altLabel' THEN formatted_object END) AS skos_altLabel,
    MAX(CASE WHEN predicate = 'skos:definition' THEN formatted_object END) AS skos_definition,
    MAX(CASE WHEN predicate = 'skos:inScheme' THEN formatted_object END) AS skos_scheme
FROM (
    SELECT
        subject,
        predicate,
        CASE
            WHEN datatype = 'xsd:boolean' THEN '"' || object || '"^^xsd:boolean'
            WHEN datatype = '@en' THEN '"' || object || '"@en'
            ELSE object
        END AS formatted_object
    FROM statement
    WHERE predicate IN ('rdf:type', 'rdfs:label', 'skos:prefLabel', 'skos:altLabel', 'skos:definition', 'skos:inScheme')
) AS formatted_objects
GROUP BY subject;
