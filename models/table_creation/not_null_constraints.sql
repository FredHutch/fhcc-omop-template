-- Set the default catalog and schema to use in all the queries below
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_schema);

-- location table
ALTER TABLE location ALTER COLUMN location_id SET NOT NULL;

-- person table
ALTER TABLE person ALTER COLUMN person_id SET NOT NULL;
ALTER TABLE person ALTER COLUMN gender_concept_id SET NOT NULL;
ALTER TABLE person ALTER COLUMN year_of_birth SET NOT NULL;
ALTER TABLE person ALTER COLUMN race_concept_id SET NOT NULL;
ALTER TABLE person ALTER COLUMN ethnicity_concept_id SET NOT NULL;

-- death table
ALTER TABLE death ALTER COLUMN person_id SET NOT NULL;
ALTER TABLE death ALTER COLUMN death_date SET NOT NULL;

-- visit_occurrence table
ALTER TABLE visit_occurrence ALTER COLUMN visit_occurrence_id SET NOT NULL;
ALTER TABLE visit_occurrence ALTER COLUMN person_id SET NOT NULL;
ALTER TABLE visit_occurrence ALTER COLUMN visit_concept_id SET NOT NULL;
ALTER TABLE visit_occurrence ALTER COLUMN visit_start_date SET NOT NULL;
ALTER TABLE visit_occurrence ALTER COLUMN visit_end_date SET NOT NULL;
ALTER TABLE visit_occurrence ALTER COLUMN visit_type_concept_id SET NOT NULL;

-- cdm_source table
ALTER TABLE cdm_source ALTER COLUMN cdm_source_name SET NOT NULL;
ALTER TABLE cdm_source ALTER COLUMN cdm_source_abbreviation SET NOT NULL;
ALTER TABLE cdm_source ALTER COLUMN cdm_holder SET NOT NULL;
ALTER TABLE cdm_source ALTER COLUMN source_release_date SET NOT NULL;
ALTER TABLE cdm_source ALTER COLUMN cdm_release_date SET NOT NULL;
ALTER TABLE cdm_source ALTER COLUMN cdm_version_concept_id SET NOT NULL;
ALTER TABLE cdm_source ALTER COLUMN vocabulary_version SET NOT NULL;

-- condition_occurrence table
ALTER TABLE condition_occurrence ALTER COLUMN condition_occurrence_id SET NOT NULL;
ALTER TABLE condition_occurrence ALTER COLUMN person_id SET NOT NULL;
ALTER TABLE condition_occurrence ALTER COLUMN condition_concept_id SET NOT NULL;
ALTER TABLE condition_occurrence ALTER COLUMN condition_start_date SET NOT NULL;
ALTER TABLE condition_occurrence ALTER COLUMN condition_type_concept_id SET NOT NULL;

-- procedure_occurrence table
ALTER TABLE procedure_occurrence ALTER COLUMN procedure_occurrence_id SET NOT NULL;
ALTER TABLE procedure_occurrence ALTER COLUMN person_id SET NOT NULL;
ALTER TABLE procedure_occurrence ALTER COLUMN procedure_concept_id SET NOT NULL;
ALTER TABLE procedure_occurrence ALTER COLUMN procedure_date SET NOT NULL;
ALTER TABLE procedure_occurrence ALTER COLUMN procedure_type_concept_id SET NOT NULL;

-- care_site table
ALTER TABLE care_site ALTER COLUMN care_site_id SET NOT NULL;

-- provider table
ALTER TABLE provider ALTER COLUMN provider_id SET NOT NULL;

-- primary keys in all other tables
ALTER TABLE observation_period ALTER COLUMN observation_period_id SET NOT NULL;
ALTER TABLE visit_detail ALTER COLUMN visit_detail_id SET NOT NULL;
ALTER TABLE drug_exposure ALTER COLUMN drug_exposure_id SET NOT NULL;
ALTER TABLE device_exposure ALTER COLUMN device_exposure_id SET NOT NULL;
ALTER TABLE measurement ALTER COLUMN measurement_id SET NOT NULL;
ALTER TABLE observation ALTER COLUMN observation_id SET NOT NULL;
ALTER TABLE note ALTER COLUMN note_id SET NOT NULL;
ALTER TABLE note_nlp ALTER COLUMN note_nlp_id SET NOT NULL;
ALTER TABLE specimen ALTER COLUMN specimen_id SET NOT NULL;
ALTER TABLE payer_plan_period ALTER COLUMN payer_plan_period_id SET NOT NULL;
ALTER TABLE cost ALTER COLUMN cost_id SET NOT NULL;
ALTER TABLE drug_era ALTER COLUMN drug_era_id SET NOT NULL;
ALTER TABLE dose_era ALTER COLUMN dose_era_id SET NOT NULL;
ALTER TABLE condition_era ALTER COLUMN condition_era_id SET NOT NULL;
ALTER TABLE episode ALTER COLUMN episode_id SET NOT NULL;
ALTER TABLE metadata ALTER COLUMN metadata_id SET NOT NULL;
ALTER TABLE concept ALTER COLUMN concept_id SET NOT NULL;
ALTER TABLE vocabulary ALTER COLUMN vocabulary_id SET NOT NULL;
ALTER TABLE domain ALTER COLUMN domain_id SET NOT NULL;
ALTER TABLE concept_class ALTER COLUMN concept_class_id SET NOT NULL;
ALTER TABLE relationship ALTER COLUMN relationship_id SET NOT NULL;

-- ****Need to add additional not null constraints for other tables as I populate them*****

