-- This file updates the vocabulary and concept tables that only get data from Athena, no custom values

-- Set the default catalog and schema to use in all the queries below
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_schema);


-- Refresh domain table based on Athena source data
INSERT OVERWRITE domain

SELECT 
  domain_id
  ,domain_name
  ,domain_concept_id
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_domain')
;

-- Referesh concept_synonym table based on Athena source data
INSERT OVERWRITE concept_synonym

SELECT 
  concept_id
  ,concept_synonym_name
  ,language_concept_id
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_concept_synonym')
;

-- Refresh concept_ancestor table based on Athena source data
-- Add records from Athena
INSERT OVERWRITE concept_ancestor

SELECT 
  ancestor_concept_id
  ,descendant_concept_id
  ,min_levels_of_separation
  ,max_levels_of_separation
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_concept_ancestor')
;

-- Refresh relationship table based on Athena source data
INSERT OVERWRITE relationship

SELECT 
  relationship_id
  ,relationship_name
  ,is_hierarchical
  ,defines_ancestry
  ,reverse_relationship_id
  ,relationship_concept_id
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_relationship')
;

-- Refresh relationship table based on Athena source data
INSERT OVERWRITE drug_strength

SELECT 
  drug_concept_id
  ,ingredient_concept_id
  ,amount_value
  ,amount_unit_concept_id
  ,numerator_value
  ,numerator_unit_concept_id
	,denominator_value
	,denominator_unit_concept_id
	,box_size
	,to_date(valid_start_date, 'yyyyMMdd') as valid_start_date
	,to_date(valid_end_date, 'yyyyMMdd') as valid_end_date
  ,invalid_reason
FROM IDENTIFIER(:omop_catalog || '.' || :omop_vocab_schema || '.' || 'athena_drug_strength')
;
