-- Create OMOP intermediate tables, not part of the OMOP CDM but used in creating the final tables

-- Set the default catalog and schema
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_intermediate_schema);

-- person_preprocessing
CREATE OR REPLACE TABLE person_preprocessing (
	person_id BIGINT NOT NULL PRIMARY KEY
	,clarity_pat_id STRING
	,uwmc_id STRING
	,pat_name STRING
	,pat_last_name STRING
	,pat_first_name STRING
	,pat_middle_name STRING
	,birth_date DATE
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- location_care_site_preprocessing
CREATE OR REPLACE TABLE location_care_site_preprocessing (
	address_1 STRING
	,address_2 STRING
	,city STRING
	,state STRING
	,zip STRING
	,county STRING
	,location_source_value STRING
	,country_concept_id INTEGER
	,country_source_value STRING
	,latitude FLOAT
	,longitude FLOAT
	,location_id BIGINT
	, care_site_type STRING
	, pos_id BIGINT
    , pos_name STRING
	, dept_id decimal(18,0)
	, dept_name STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- care_site_raw
CREATE OR REPLACE TABLE care_site_raw (
	care_site_id BIGINT
	, care_site_name STRING
	, place_of_service_concept_id integer
	, location_id BIGINT
	, care_site_source_value STRING
	, place_of_service_source_value STRING
	, care_site_type STRING
	, pos_id BIGINT
    , pos_name STRING
	, dept_id decimal(18,0)
	, dept_name STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- location_person_preprocessing
CREATE OR REPLACE TABLE location_person_preprocessing (
	person_id BIGINT NOT NULL PRIMARY KEY
	,address_1 STRING
	,address_2 STRING
	,city STRING
	,state STRING
	,zip STRING
	,county STRING
	,location_source_value STRING
	,country_concept_id INTEGER
	,country_source_value STRING
	,latitude FLOAT
	,longitude FLOAT
	,location_id BIGINT
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create the table to use for the raw version of the visit_occurrence data with extra columns.
CREATE OR REPLACE TABLE visit_occurrence_raw  ( 
	visit_occurrence_id BIGINT NOT NULL PRIMARY KEY,
	person_id BIGINT,
	visit_start_datetime TIMESTAMP,
  visit_start_date DATE,
  visit_end_preliminary TIMESTAMP,
  visit_end_datetime TIMESTAMP,
  visit_end_date DATE,
  visit_length_days INTEGER,
  visit_concept_id INTEGER,
	visit_type_concept_id INTEGER,
	provider_id BIGINT,
	care_site_id BIGINT,
	visit_source_value STRING,
	visit_source_concept_id INTEGER,
	admitted_from_concept_id INTEGER,
	admitted_from_source_value STRING,
	discharged_to_concept_id INTEGER,
	discharged_to_source_value STRING,
	preceding_visit_occurrence_id BIGINT,
  provider_source_value STRING,
  enc_type_c STRING,
  department_id DECIMAL(18),
  department_name STRING,
  hosp_admsn_time TIMESTAMP,
  adt_pat_class_c STRING,
  zc_pat_class_name STRING,
  csn_id DECIMAL(18),
  hsp_account_id DECIMAL(18),
  hsp_discharge_source_code STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create the table to use for the filtered version of visit_occurrence
CREATE OR REPLACE TABLE visit_occurrence_filtered  ( 
	visit_occurrence_id BIGINT NOT NULL PRIMARY KEY,
	person_id BIGINT,
	visit_start_datetime TIMESTAMP,
  visit_start_date DATE,
  visit_end_preliminary TIMESTAMP,
  visit_end_datetime TIMESTAMP,
  visit_end_date DATE,
  visit_length_days INTEGER,
  visit_concept_id INTEGER,
	visit_type_concept_id INTEGER,
	provider_id BIGINT,
	care_site_id BIGINT,
	visit_source_value STRING,
	visit_source_concept_id INTEGER,
	admitted_from_concept_id INTEGER,
	admitted_from_source_value STRING,
	discharged_to_concept_id INTEGER,
	discharged_to_source_value STRING,
	preceding_visit_occurrence_id BIGINT,
  provider_source_value STRING,
  enc_type_c STRING,
  department_id DECIMAL(18),
  department_name STRING,
  hosp_admsn_time TIMESTAMP,
  adt_pat_class_c STRING,
  zc_pat_class_name STRING,
  csn_id DECIMAL(18),
  hsp_account_id DECIMAL(18),
  hsp_discharge_source_code STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

  
-- Create the table to use for the raw version of the condition_occurrence data with an extra columns indicating the data source
CREATE OR REPLACE TABLE condition_occurrence_raw  ( 
	condition_occurrence_id BIGINT NOT NULL PRIMARY KEY,
	person_id BIGINT NOT NULL,
	condition_concept_id integer NOT NULL,
	condition_start_date date NOT NULL,
	condition_start_datetime TIMESTAMP,
	condition_end_date date,
	condition_end_datetime TIMESTAMP,
	condition_type_concept_id integer NOT NULL,
	condition_status_concept_id integer,
	stop_reason string,
	provider_id BIGINT,
	visit_occurrence_id BIGINT,
	visit_detail_id BIGINT,	
	condition_source_value STRING,
	condition_source_concept_id integer,
	condition_status_source_value STRING,
	condition_source_name STRING,
	condition_source_table STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
  
-- Create the table to use for the raw version of the procedure_occurrence data with extra columns.
CREATE OR REPLACE TABLE procedure_occurrence_raw  ( 
	procedure_occurrence_id BIGINT NOT NULL PRIMARY KEY,
	person_id BIGINT NOT NULL,
	procedure_concept_id integer NOT NULL,
	procedure_date date NOT NULL,
	procedure_datetime TIMESTAMP,
	procedure_end_date date,
	procedure_end_datetime TIMESTAMP,
	procedure_type_concept_id integer NOT NULL,
	modifier_concept_id integer,
	quantity integer,
	provider_id BIGINT,
	visit_occurrence_id BIGINT,
	visit_detail_id BIGINT,
	procedure_source_value STRING,
	procedure_source_concept_id integer,
	modifier_source_value STRING,
	source_record_type STRING,
	order_class_c STRING,
	procedure_source_code STRING,
	procedure_source_value_type STRING,
	procedure_source_name STRING,
	procedure_concept_name STRING,
	procedure_source_table STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;


-- Create the table to use for the raw version of the measurement data with extra columns.
CREATE OR REPLACE TABLE measurement_raw  ( 
	measurement_id BIGINT NOT NULL PRIMARY KEY,
	person_id BIGINT NOT NULL,
	measurement_concept_id integer NOT NULL,
	measurement_date date NOT NULL,
	measurement_datetime TIMESTAMP,
	measurement_time STRING,
	measurement_type_concept_id integer NOT NULL,
	operator_concept_id integer,
	value_as_number double,
	value_as_concept_id INTEGER,
	unit_concept_id INTEGER,
	range_low DOUBLE,
	range_high DOUBLE,
	provider_id BIGINT,
	visit_occurrence_id BIGINT,
	visit_detail_id BIGINT,
	measurement_source_value STRING,
	measurement_source_concept_id integer,
	unit_source_value STRING,
	unit_source_concept_id INTEGER,
	value_source_value STRING,
	measurement_event_id INTEGER,
	meas_event_field_concept_id INTEGER,
	-- extra columns
	clarity_source_table STRING,
    proc_code STRING,
    component_name STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create the table to use for the raw version of the drug_exposrue data with extra columns
CREATE OR REPLACE TABLE drug_exposure_raw  ( 
	drug_exposure_id BIGINT NOT NULL PRIMARY KEY
  , person_id BIGINT NOT NULL
  , drug_concept_id integer NOT NULL
  , drug_exposure_start_date date NOT NULL
  , drug_exposure_start_datetime TIMESTAMP
  , drug_exposure_end_date DATE
  , drug_exposure_end_datetime TIMESTAMP
  , verbatim_end_date DATE
  , drug_type_concept_id integer
  , stop_reason STRING
  , refills integer
  , quantity integer
  , days_supply integer
  , sig STRING
  , route_concept_id integer
  , lot_number integer
  , provider_id BIGINT
  , visit_occurrence_id BIGINT
  , visit_detail_id integer
  , drug_source_value STRING
  , drug_source_concept_id integer
  , route_source_value STRING
  , dose_unit_source_value STRING
  , order_class_c STRING
  , order_status_c STRING
  , display_name STRING
  , gpi STRING
  , investigatl_med_yn STRING
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create the table for the drug_exposure mapping table to use in checks
CREATE OR REPLACE TABLE drug_exposure_mapping  ( 
	dispensable_med_id STRING
  , name STRING
  , drug_id STRING
  , drug_concept_id INT
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create intermediate observation table with research study information
CREATE OR REPLACE TABLE observation_research_study  (
	observation_id BIGINT NOT NULL PRIMARY KEY
	, person_id BIGINT NOT NULL
	, observation_concept_id integer NOT NULL
	, observation_date date NOT NULL
	, observation_datetime TIMESTAMP
	, observation_type_concept_id integer NOT NULL
	, value_as_number float
	, value_as_string STRING
	, value_as_concept_id integer
	, qualifier_concept_id integer
	, unit_concept_id integer
	, provider_id BIGINT
	, visit_occurrence_id BIGINT
	, visit_detail_id BIGINT
	, observation_source_value STRING
	, observation_source_concept_id integer
	, unit_source_value STRING
	, qualifier_source_value STRING
	, value_source_value STRING
	, observation_event_id INTEGER
	, obs_event_field_concept_id INTEGER
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create intermediate observation table with all data for the de-id process
CREATE OR REPLACE TABLE observation (
	observation_id BIGINT NOT NULL PRIMARY KEY
	, person_id BIGINT NOT NULL
	, observation_concept_id integer NOT NULL
	, observation_date date NOT NULL
	, observation_datetime TIMESTAMP
	, observation_type_concept_id integer NOT NULL
	, value_as_number float
	, value_as_string STRING
	, value_as_concept_id integer
	, qualifier_concept_id integer
	, unit_concept_id integer
	, provider_id BIGINT
	, visit_occurrence_id BIGINT
	, visit_detail_id BIGINT
	, observation_source_value STRING
	, observation_source_concept_id integer
	, unit_source_value STRING
	, qualifier_source_value STRING
	, value_source_value STRING
	, observation_event_id INTEGER
	, obs_event_field_concept_id INTEGER
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create mapping table for visit_ocurrence visit types
CREATE OR REPLACE TABLE visit_mapping_rules (
	rule_id bigint
	, active_flag string
	, enc_type_c bigint
	, enc_type_cname string
	, adt_pat_class_c bigint
	, adt_pat_class_name string
	, department_group string
	, include_in_visit_occurrence boolean
	, visit_concept_id bigint
	, visit_concept_name string
	, visit_source_value string
	, mapping_rationale string
	, effective_start_date date
	, effective_end_date date
	, mapping_status string
	, last_reviewed_date date
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;

-- Create mapping table for visit_ocurrence department groups
CREATE OR REPLACE TABLE department_groups (
	department_id bigint
	, DEPARTMENT_NAME string
	, external_name string
	, SERV_AREA_ID decimal(18,0)
	, DEPT_ABBREVIATION string
	, SPECIALTY string
	, department_group string
	, mapping_rationale string
)
USING DELTA
TBLPROPERTIES(
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
;
