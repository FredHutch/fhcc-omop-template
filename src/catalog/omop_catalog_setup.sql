-- Setup the catalog curated_omop to hold OMOP data in production

-- Create the catalog
CREATE CATALOG IF NOT EXISTS curated_omop COMMENT 'OMOP CDM data in the production environment.';

-- Set the tags
SET TAG ON CATALOG curated_omop layer = gold;
SET TAG ON CATALOG curated_omop contains_pii = true;
SET TAG ON CATALOG curated_omop data_classification = `Restricted Use`;

-- Grant "Data Editor" permissions to Data Steward
GRANT CREATE TABLE, MODIFY, WRITE VOLUME, SELECT, BROWSE, USE CATALOG, CREATE SCHEMA, READ VOLUME, CREATE MODEL, USE SCHEMA, CREATE VOLUME, CREATE MATERIALIZED VIEW, APPLY TAG, CREATE FUNCTION
ON CATALOG curated_omop
TO `Data Steward`;

-- Grant Data Governance permissions
GRANT MANAGE, SELECT, APPLY TAG, READ VOLUME, EXECUTE, BROWSE, USE CATALOG, USE SCHEMA
ON CATALOG curated_omop
TO `Data Governance`;

-- Grant System Owners permissions
GRANT MANAGE, ALL PRIVILEGES
ON CATALOG curated_omop
TO `System Owners`;

-- Grant browse permissions to all account users
GRANT BROWSE 
ON CATALOG curated_omop
TO `account users`;

-- Grant "Data Editor" permission to the service principle for this workspace
GRANT CREATE TABLE, MODIFY, WRITE VOLUME, SELECT, BROWSE, USE CATALOG, CREATE SCHEMA, READ VOLUME, CREATE MODEL, USE SCHEMA, CREATE VOLUME, CREATE MATERIALIZED VIEW, APPLY TAG, CREATE FUNCTION
ON CATALOG curated_omop
TO `12345678-1234-1234-1234-1234567890ab`;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS curated_omop.omop;
CREATE SCHEMA IF NOT EXISTS curated_omop.omop_intermediate;
CREATE SCHEMA IF NOT EXISTS curated_omop.omop_monitoring;
CREATE SCHEMA IF NOT EXISTS curated_omop.omop_vocab;
CREATE SCHEMA IF NOT EXISTS curated_omop.omop_dqd;
