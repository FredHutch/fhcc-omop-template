---
name: populate-new-omop-table
description: Step-by-step guide for creating all artifacts needed to populate a new OMOP CDM table in the omop-cdm-v5.4 project. Read this skill when the user asks to add a new table to the OMOP CDM pipeline, create transformation code for an OMOP table, or scaffold the files needed for a new OMOP domain table.
---

# Populate New OMOP Table

This skill documents the complete process for adding a new OMOP CDM table to the `omop-cdm-v5.4` project.

## Project Structure

All OMOP table artifacts live under:
```
omop-cdm-v5.4/models/<table_name>/
```

Each table folder contains exactly 4 files:
```
models/<table_name>/
├── <table_name>.md                        # Requirements documentation
├── <table_name>_comments.sql              # Table/column COMMENT ON statements
├── <table_name>_checks.yml                # DQX data quality checks
└── populate_<table_name>_table.sql        # Transformation SQL
```

Additionally, a task entry must be added to:
```
resources/jobs/omop_table_refresh.job.yml
```

Additionally, related DQX checks information must be added to:
```
monitoring/
```

---

## Step 1: Create the Requirements Documentation (`.md` file)

**File:** `models/<table_name>/<table_name>.md`

This documents the business rules, source tables, ETL steps, data quality monitoring plan, and column-level details.

### Template Structure

```markdown
# OMOP CDM Requirements Definitions for <*Table Name*> **Table

## Overview

*High level overview of the data included in the table (3-4 sentences max). This text will be utilized the the table comment/description in CARDS Unity Catalog.*

## Key Business Rules

*Bulleted list of key rules that must be applied to the transformations, in plain language (e.g., future visits are removed, persons with missing birthdate are removed).*

- 
- 
- 

## Source Tables

*Bulleted list of all tables referenced in creation of the final table include both primary data tables, reference tables for mapping codes, and upstream OMOP CDM tables.*

### Primary Tables

#### **Schema Name** (`schema path`)

- **Table Name** - what it is (e.g. "PAT_ENC_DX - encounter diagnoses")
- 
- 

### **Reference Tables**

#### **Schema Name** (`schema path`)

- **Table Name** - summary of data utilized from this table
- 
- 

### Upstream OMOP CDM Tables

#### **Schema Name** (`schema path`)

- **Table Name** - summary of data utilized from this table
- 
- 

## ETL Steps

*Numbered list of chronological steps for data processing and intermediate tables created at that stage. Code snippets are used to provide additional detail as helpful, and these only include table names not the corresponding* full table path since that is defined in the Source Tables section above

1. **summary title for step** - description of step
2. 
3. 

## Data Quality Monitoring

### Summary Metrics

*Bulleted list of summary-level data quality monitoring for this table. These may be indicative of a problem in source data or issues with transformation logic.*

- 
- 
- 

### Record-Level Checks

*Bulleted list summarizing the record-level checks applied using DQX package.*

- 
- 
- 

## Column Details

Table summarizing key characteristics of each column in the table:

- **Column Name** - column name in the final OMOP CDM table
- **Data Type**  - usually the data type outlined in [OMOP CDM v5.4](https://ohdsi.github.io/CommonDataModel/cdm54.html), but some differences may exist (e.g BIGINT instead of Integer)
- **Source Field** - table and columns that served as the source data, not including the full table path since that is defined for the table in the Source Tables section above. When multiple columns are used in mapping codes the details are included in the Logic column.
- **Logic** - ETL logic applied to that source data to create the value that appears in the final data, using succinct code or pseudo-code when helpful. This column does not include the reasoning behind the logic decisions.
- **Constraints** - constraints applied to the column such as non-null or no duplicates; primary and foreign key constraints are not included in this list since in Databricks they are [informational only and are not enforced](https://docs.databricks.com/aws/en/tables/constraints#declare-primary-key-and-foreign-key-relationships)

| **Column Name** | **Data Type** | **Source Field(s)** | **Logic** | **Constraints** |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |
|  |  |  |  |  |

## Change Log

*A summary of updates made to this table organized under the associated with each Fred Hutch OMOP numbered release version.*

### v1.1.0
Initial version.

## Potential Future Work

*While not providing detailed tracking all open issues/ideas for this table, this provides a high-level summary of potential future improvements to the table that may impact how users utilize the data now or in the future.*
```

### Key Guidelines

- Link to the OMOP CDM 5.4 documentation for the table
- Be explicit about COALESCE logic for dates/times
- Document which encounter/record types are included vs excluded
- List all source columns used in joins and filters
- Specify NULL handling for optional vs required OMOP fields
- Document visit_concept_id or equivalent categorical mapping logic in detail

---

## Step 2: Create the Comments File (`.sql`)

**File:** `models/<table_name>/<table_name>_comments.sql`

This file sets table and column comments in Unity Catalog using parameterized catalog/schema references.

### Template

```sql
-- Table and column comments for <table_name> table

-- Set the default catalog and schema
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_schema);

-- Set all the table and column comments
-- We have only added comments to columns where our implementation is not covered by the OMOP CDM documentation.
COMMENT ON TABLE <table_name> IS '<Table-level description referencing OMOP CDM 5.4 docs URL>';
COMMENT ON COLUMN <table_name>.<column_1> IS '<Explain implementation-specific logic>';
COMMENT ON COLUMN <table_name>.<column_2> IS '<Explain implementation-specific logic>';
```

### Key Guidelines

- Use `:omop_catalog` and `:omop_schema` parameters (not hardcoded values)
- Include the OMOP CDM 5.4 docs URL in the table comment
- Explain any NULLs that exist because upstream tables aren't yet populated (e.g., provider_id, care_site_id)
- Include comments for all columns in the table defined in `omop-cdm-v5.4/models/table_creation/table_creation.sql`

---


## Step 3: Add NOT NULL Constraints

**File:** `models/table_creation/not_null_constraints.sql`

Add `ALTER TABLE ... ALTER COLUMN ... SET NOT NULL` statements **only** for columns where the "Required" column is "Yes" in the OMOP CDM v5.4 specification: https://ohdsi.github.io/CommonDataModel/cdm54.html

**Important:** Each table has its own set of required columns — do not assume which columns are required. Always check the OHDSI documentation page for the specific table (`https://ohdsi.github.io/CommonDataModel/cdm54.html#<table_name>`) and look at the "Required" column in the field-level table. For example, the `provider` table only requires `provider_id`, while clinical event tables like `condition_occurrence` require several columns.

### Template

```sql
-- <table_name> table
ALTER TABLE <table_name> ALTER COLUMN <required_column_1> SET NOT NULL;
ALTER TABLE <table_name> ALTER COLUMN <required_column_2> SET NOT NULL;
```

### Key Guidelines

- Reference the OMOP CDM v5.4 docs page for the table to identify which columns are required: `https://ohdsi.github.io/CommonDataModel/cdm54.html#<table_name>`
- **Only** add NOT NULL constraints for columns where Required = "Yes" in the OHDSI documentation — do not infer or assume required status based on column naming patterns
- Place the new block in the file grouped with other fully-populated tables (above the `-- primary keys in all other tables` section), following the existing comment pattern `-- <table_name> table`
- If the table previously only had its primary key listed in the "primary keys in all other tables" section at the bottom, remove that line and replace it with the full block
- This file uses parameterized `USE CATALOG IDENTIFIER(:omop_catalog)` and `USE SCHEMA IDENTIFIER(:omop_schema)` at the top — no need to repeat those in the new block

  ---

## Step 4: Create the DQX Checks File (`.yml`)

**File:** `models/<table_name>/<table_name>_checks.yml`

This defines data quality checks run by `databricks-labs-dqx`. Each check has a criticality level (`error` or `warn`) and a check function.

### Template

```yaml
- criticality: error
  check:
    function: is_not_null_and_not_empty
    arguments:
      column: <primary_key_column>
- criticality: error
  check:
    function: is_unique
    arguments:
      columns:
      - <primary_key_column>
- criticality: error
  check:
    function: is_not_null_and_not_empty
    arguments:
      column: person_id
- criticality: warn
  check:
    function: is_valid_date
    arguments:
      column: <start_date_column>
- criticality: error
  check:
    function: is_not_null_and_not_empty
    arguments:
      column: <start_date_column>
- criticality: warn
  check:
    function: is_valid_date
    arguments:
      column: <end_date_column>
- criticality: warn
  check:
    function: is_not_greater_than
    arguments:
      column: <start_date_column>
      limit: <end_date_column>
- criticality: error
  check:
    function: is_not_null_and_not_empty
    arguments:
      column: <end_date_column>
- criticality: warn
  check:
    function: is_valid_timestamp
    arguments:
      column: <start_datetime_column>
- criticality: warn
  check:
    function: is_not_in_future
    arguments:
      column: <start_datetime_column>
- criticality: warn
  check:
    function: is_valid_timestamp
    arguments:
      column: <end_datetime_column>
- criticality: warn
  check:
    function: is_not_in_future
    arguments:
      column: <end_datetime_column>
```

You can specicify muliple columns to apply `is_unique` as a list within the `columns` argument. For other functions, you can use `for_each_column` to specificy multiple columns to apply the check to, for example:
```
- name: cols_not_null_or_empty
  criticality: error
  check:
    function: is_not_null_and_not_empty
    for_each_column:
      - col1
      - col2
    arguments:
      trim_strings: true
```



### Available DQX Check Functions

| Function | Arguments | Use For |
| --- | --- | --- |
| `is_not_null_and_not_empty` | `column` | Required OMOP fields |
| `is_unique` | `columns` (list) | Primary key columns |
| `is_valid_date` | `column` | Date columns |
| `is_valid_timestamp` | `column` | Datetime columns |
| `is_not_in_future` | `column` | Dates/timestamps that should not be future |
| `is_not_greater_than` | `column`, `limit` | Start date <= end date |

### Key Guidelines

- Primary key: always `error` for `is_not_null_and_not_empty` AND `is_unique`. The primary key for the table is defined in `omop-cdm-v5.4/models/table_creation/primary_key_constraints.sql`
- `person_id`: always `error` for `is_not_null_and_not_empty`
- Required OMOP fields: `error` for not null. Determine which fields are required by checking the "Required" column (= "Yes") in the OHDSI documentation for the specific table: `https://ohdsi.github.io/CommonDataModel/cdm54.html#<table_name>`. These should match the NOT NULL constraints defined in Step 3 of this skill.
- Date validity and future checks: `warn`
- Start <= end date comparisons: `warn`
- Only include checks for columns that exist in the table

---

## Step 5: Create the Transformation SQL (`.sql`)

**File:** `models/<table_name>/populate_<table_name>_table.sql`

This is the main ETL SQL that refreshes the OMOP table.

### Template Structure

```sql
-- This file refreshes the OMOP <table_name> table

-- Set the default catalog and schema to use in all the queries below
USE CATALOG IDENTIFIER(:omop_catalog);
USE SCHEMA IDENTIFIER(:omop_schema);

-- <Optional: Create temporary mapping tables for vocabulary lookups>
DROP TEMPORARY TABLE IF EXISTS <mapping_table>;
CREATE TEMPORARY TABLE <mapping_table> AS
<mapping query using concept and concept_relationship tables>;

-- Populate <table_name> (or intermediate raw table)
INSERT OVERWRITE IDENTIFIER(:omop_catalog || '.' || :omop_intermediate_schema || '.' || '<table_name>_raw')

SELECT DISTINCT
    abs(xxhash64('clarity', <source_primary_key>)) AS <table_name>_id,
    person.person_id AS person_id,
    <column mappings...>
FROM IDENTIFIER(:omop_catalog || '.' || :omop_intermediate_schema || '.' || 'person_preprocessing') AS person_preprocessing
INNER JOIN IDENTIFIER(:omop_catalog || '.' || :omop_schema || '.' || 'person') AS person
    ON person_preprocessing.person_id = person.person_id
INNER JOIN IDENTIFIER(:clarity_catalog || '.' || :clarity_daily_schema || '.' || '<source_table>') AS <alias>
    ON person_preprocessing.pat_id = <alias>.pat_id
<additional joins...>
WHERE <inclusion criteria>;

-- Final table population (from raw to final, adding window functions like preceding IDs)
INSERT OVERWRITE IDENTIFIER(:omop_catalog || '.' || :omop_schema || '.' || '<table_name>')
SELECT
    <columns>
FROM IDENTIFIER(:omop_catalog || '.' || :omop_intermediate_schema || '.' || '<table_name>_raw');
```

### Key Patterns

- **Parameterized identifiers**: Always use `:omop_catalog`, `:omop_schema`, `:omop_intermediate_schema`, `:clarity_catalog`, `:clarity_daily_schema`, `:clarity_weekly_schema` — never hardcode catalog/schema names
- **Primary key generation**: Use `abs(xxhash64('clarity', <source_key>))` to generate deterministic BIGINT IDs from source keys
- **Person join pattern**: Always join through `person_preprocessing` → `person` to limit to included patients
- **Two-stage pattern**: Some tables use an intermediate `_raw` table in `omop_intermediate_schema`, then a final `INSERT OVERWRITE` into the target schema (useful when window functions like LAG need the full dataset)
- **COALESCE for dates**: Use COALESCE with multiple source date columns ordered by preference
- **Concept mapping**: Use temporary tables joining `concept` and `concept_relationship` for vocabulary mappings
- **INSERT OVERWRITE**: Always use `INSERT OVERWRITE` (not MERGE or CREATE OR REPLACE) for idempotent refreshes
- **Columns** - identify the columns that should be present in the intermediate and final tables from `omop-cdm-v5.4/models/table_creation/table_creation.sql`

---

## Step 6: Add DQX related information so the defined checks will run

So that the DQX checks defined in Step 4 will runL

1. In `monitoring/monitoring_table_creation.sql` add the creation of a new table `<table_name>_quarantine`  following the same pattern used for the other tables.
2. In `monitoring/omop_dqx_monitoring_tables.yml` add a row for this new table following the pattern used for the other tables.

---

## Checklist

When creating a new OMOP table, complete these steps in order:

- [ ] Create folder: `models/<table_name>/`
- [ ] Create `<table_name>.md` with full requirements documentation
- [ ] Create `<table_name>_comments.sql` with COMMENT ON statements
- [ ] Add NOT NULL constraints to `models/table_creation/not_null_constraints.sql` only for columns where Required = "Yes" in the OHDSI OMOP CDM v5.4 documentation for the table
- [ ] Create `<table_name>_checks.yml` with DQX validation rules
- [ ] Create `populate_<table_name>_table.sql` with transformation SQL
- [ ] Add DQX related information so the defined checks will run

---

## Reference: Existing Tables

Use these as working examples:

| Table | Folder | Key Pattern |
| --- | --- | --- |
| `visit_occurrence` | `models/visit_occurrence/` | Two-stage (raw → final with LAG), vocabulary mapping via temp tables |
| `condition_occurrence` | `models/condition_occurrence/` | Uses `clarity_weekly_schema` for reference tables |
| `procedure_occurrence` | `models/procedure_occurrence/` | Similar to condition_occurrence |
| `measurement` | `models/measurement/` | Uses `clarity_weekly_schema` |
| `drug_exposure` | `models/drug_exposure/` | Uses `clarity_weekly_schema` |
| `person` | `models/person/` | Foundation table, depends on location |
| `death` | `models/death/` | Simpler pattern, depends on person |
| `location` | `models/location/` |  |
