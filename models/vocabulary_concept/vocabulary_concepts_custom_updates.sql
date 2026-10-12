-- This file updates the vocabulary and concept tables with both custom and Athena sources

-- Set the default catalog and schema to use in all the queries below
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_schema);


-- Refresh vocabulary table
INSERT OVERWRITE vocabulary

SELECT 
  vocabulary_id
  ,vocabulary_name
  ,vocabulary_reference
  ,vocabulary_version
  ,vocabulary_concept_id
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_vocabulary')

UNION -- prevents duplicates

SELECT 
  vocabulary_id
  ,vocabulary_name
  ,vocabulary_reference
  ,vocabulary_version
  ,vocabulary_concept_id
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'custom_vocabulary')
;

-- Refresh concept table
INSERT OVERWRITE concept

SELECT 
  concept_id
	,concept_name
	,domain_id
	,vocabulary_id
	,concept_class_id
	,standard_concept
	,concept_code
	,to_date(valid_start_date, 'yyyyMMdd') as valid_start_date
	,to_date(valid_end_date, 'yyyyMMdd') as valid_end_date
	,invalid_reason
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_concept')

UNION -- prevents duplicates

SELECT 
  concept_id
	,concept_name
	,domain_id
	,vocabulary_id
	,concept_class_id
	,standard_concept
	,concept_code
	,to_date(valid_start_date, 'yyyyMMdd') as valid_start_date
	,to_date(valid_end_date, 'yyyyMMdd') as valid_end_date
	,invalid_reason
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'custom_concept')
WHERE concept_id IS NOT NULL
;

-- Refresh concept_relationship table
INSERT OVERWRITE concept_relationship

-- The Athena concept_relationship data is in a volume since the file was too large to be uploaded directly 
-- to a table and it seemed potentially error prone to spit it up into multiple files
SELECT 
  concept_id_1
	,concept_id_2
	,relationship_id
	,to_date(valid_start_date, 'yyyyMMdd') as valid_start_date
	,to_date(valid_end_date, 'yyyyMMdd') as valid_end_date
	,invalid_reason
FROM read_files(
  '/Volumes/' || :omop_catalog || '/' || :omop_vocab_schema || '/athena_concept_relationship/CONCEPT_RELATIONSHIP.csv',
  format => 'csv',  -- Even for TSV, use 'csv' format and specify the delimiter
  delimiter => '\t', -- tab separated file format
  header => 'true', -- If the file has a header row
  inferSchema => 'true', -- To automatically infer column data types
  mode => 'FAILFAST',
  schemaEvolutionMode => 'none' -- Will not return _rescue_data column
)

UNION -- prevents duplicates

SELECT 
  concept_id_1
	,concept_id_2
	,relationship_id
	,to_date(valid_start_date, 'yyyyMMdd') as valid_start_date
	,to_date(valid_end_date, 'yyyyMMdd') as valid_end_date
	,invalid_reason
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'custom_concept_relationship')
;

-- Refresh concept_class table based on Athena and custom concept data
INSERT OVERWRITE concept_class

SELECT 
  concept_class_id
  ,concept_class_name
  ,concept_class_concept_id
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_concept_class')

UNION -- prevents duplicates

SELECT 
  concept_class_id
  ,concept_class_name
  ,concept_class_concept_id
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'custom_concept_class')
;