-- Create tables used for OMOP monitoring

-- Set the default catalog and schema
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_schema);

-- Create table for overall monitoring metrics
CREATE OR REPLACE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'dqx_metrics') (
	catalog STRING
  ,schema STRING
  ,table STRING
  ,monitoring_timestamp TIMESTAMP
  ,input_row_count INT
  ,error_row_count INT
  ,warning_row_count INT
  ,valid_row_count INT
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- location_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'location_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'location_quarantine') LIKE location
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'location_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'location_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'location_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;


-- person_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'person_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'person_quarantine') LIKE person
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'person_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'person_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'person_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- death_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'death_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'death_quarantine') LIKE death
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'death_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'death_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'death_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- visit_occurrence_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'visit_occurrence_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'visit_occurrence_quarantine') LIKE visit_occurrence
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'visit_occurrence_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'visit_occurrence_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'visit_occurrence_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- condition_occurrence_monitoring same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'condition_occurrence_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'condition_occurrence_quarantine') LIKE condition_occurrence
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'condition_occurrence_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'condition_occurrence_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'condition_occurrence_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- procedure_occurrence_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'procedure_occurrence_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'procedure_occurrence_quarantine') LIKE procedure_occurrence
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'procedure_occurrence_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'procedure_occurrence_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'procedure_occurrence_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- measurement_monitoring same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'measurement_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'measurement_quarantine') LIKE measurement
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'measurement_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'measurement_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'measurement_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- drug_exposure_monitoring same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'drug_exposure_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'drug_exposure_quarantine') LIKE drug_exposure
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'drug_exposure_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'drug_exposure_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'drug_exposure_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- observation_period_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'observation_period_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'observation_period_quarantine') LIKE observation_period
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'observation_period_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'observation_period_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'observation_period_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;


-- cdm_source_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'cdm_source_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'cdm_source_quarantine') LIKE cdm_source
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'cdm_source_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'cdm_source_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'cdm_source_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- care_site_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'care_site_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'care_site_quarantine') LIKE care_site
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'care_site_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'care_site_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'care_site_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- fact_relationship_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'fact_relationship_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'fact_relationship_quarantine') LIKE fact_relationship
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'fact_relationship_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'fact_relationship_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'fact_relationship_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- provider_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'provider_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'provider_quarantine') LIKE provider
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'provider_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'provider_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'provider_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;

-- note_quarantine same as the original table with added _error and _warn columns
DROP TABLE IF EXISTS IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'note_quarantine');
CREATE TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'note_quarantine') LIKE note
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'note_quarantine') ADD COLUMN _errors STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'note_quarantine') ADD COLUMN _warnings STRING;
ALTER TABLE IDENTIFIER(:omop_catalog || '.' || :omop_monitoring_schema || '.' || 'note_quarantine') ADD COLUMN dqx_run_timestamp TIMESTAMP;
