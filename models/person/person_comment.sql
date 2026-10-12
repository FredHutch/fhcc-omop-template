-- Table and column comments for person table

-- Set the default catalog and schema
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_schema);

-- Set all the table and column comments
-- We have only added comments to columns where our implementation is not covered by the OMOP CDM documentation.
COMMENT ON TABLE person IS 'This table serves as the central identity management for all patients included this OMOP implemenation, with one records for each patient. See columns comments regarding this specific OMOP CDM implementation and the OMOP CDM 5.4 documentation for general guidelines for this table (https://ohdsi.github.io/CommonDataModel/cdm54.html#person)';
COMMENT ON COLUMN person.person_id IS 'Number uniquely identifying each person in the data. This is derived using a hash function and consistently refers to the same person over time.';
COMMENT ON COLUMN person.gender_concept_id IS 'OMOP standard concept representing sex assigned at birth (NOT gender identity). It is determined based on the following logic: (1) if the patient has selected male or female on the SOGI questionnaire for “What sex were you assigned at birth on your original birth certificate?”, this value is used, (2) else, the Epic field for legal sex (SEX_C in patient table) is used if it is male or female, (3) else, gender_concept_id is 0 and the gender_source_value is “Unknown"';
COMMENT ON COLUMN person.birth_datetime IS 'The date and time of of birth of the person, when both are available. NULL when the time of birth is not available.';
COMMENT ON COLUMN person.race_concept_id IS 'OMOP standard concept that captures race or ethnic background of the person. When multiple race values are available only the first is used.';
COMMENT ON COLUMN person.ethnicity_concept_id IS 'OMOP standard concept that captures the ethnicity of the person, currently distinguishing only between “Hispanic” and “Not Hispanic” in the Epic source data.';
COMMENT ON COLUMN person.location_id IS 'Maps to location.location_id to provide the address for this patient';
COMMENT ON COLUMN person.provider_id IS 'Primary care provider for the person; NULL if that is not available. This may only be available if that provider is within the University of Washington Medicine system.';
COMMENT ON COLUMN person.care_site_id IS "Care site indicating the patient's primary place of service.";
COMMENT ON COLUMN person.person_source_value IS 'UWMC MRN ("U Number").';
COMMENT ON COLUMN person.gender_source_value IS 'Sex assigned at birth of the person from the Epic Clarity source data with logic as defined for the gender_concept_id column.';
COMMENT ON COLUMN person.gender_source_concept_id IS 'Custom concept representing the sex of the person from the Epic Clarity source data with logic as defined for the gender_concept_id column.';
COMMENT ON COLUMN person.race_source_value IS 'Race of the person from the Epic Clarity source data.';
COMMENT ON COLUMN person.race_source_concept_id IS 'Custom concept representing the race of the person from the Epic Clarity source data.';
COMMENT ON COLUMN person.ethnicity_source_value IS 'Ethnic background of the person from the Epic Clarity source data.';
COMMENT ON COLUMN person.ethnicity_source_concept_id IS 'Custom concept representing the ethnic background of the person from the Epic Clarity source data.';
COMMENT ON COLUMN person.birth_date IS 'Year, month, and day of birth of the person in date format (YYYY-MM-DD). Not a standard OMOP CDM column.';
