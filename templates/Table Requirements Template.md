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

### v0.5.0

## Potential Future Work

*While not providing detailed tracking all open issues/ideas for this table, this provides a high-level summary of potential future improvements to the table that may impact how users utilize the data now or in the future.*
