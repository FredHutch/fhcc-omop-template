# OMOP Technical Implementation

## Goal/Purpose

Identify, plan, and implement the process for enacting the tasks, jobs, alerts, testing, dashboards, and more within Databricks in a way that utilizes Databricks efficiency and automation features while maintaining consistency with OMOP standards and the FHCC defined "High-Level OMOP Requirements".

## Environments

<aside>
💡

**Summary**: Git repository branches will correspond to Databricks environments.

</aside>

In the CARDS Databricks there are 3 environments. Below is a summary of how these will be used for OMOP development:

- **production** - only data created through code on the `main` branch of the repo as part of a versioned release will be available here
- **test** - all development and testing of new features will occur here. The `curated_omop_test` schema will be created off the `dev` branch of the repo

## Schema Organization

<aside>
💡

**Summary**: We will use schemas to separate the final transformation data (in the `omop` schema) from intermediate and complementary data. 

</aside>

Within the `curated_omop` catalog in the production environment and the `curated_omop_test` catalog in the test environment the schemas include:

- **omop** – final OMOP tables, with table names within the schema corresponding to those defined in the OMOP CDM v5.4 requirements
- **omop_intermediate** – intermediate tables used in generating the OMOP CDM tables, with informative names describing table contents.
- **omop_vocab** - vocabulary related tables uploaded from CSV files, including both standard OMOP vocabularies accessed from [Athena](https://athena.ohdsi.org/) and custom vocabularies (tracked in the repo within `vocabulary/custom` folder). The tables in this schema are used in creating the final OMOP CDM vocabulary related tables that live in the `omop` schema
- **omop_monitoring** - contains tables for monitoring data quality of final OMOP tables
- **information_schema** - Databricks Unity Catalog standard, automatically created, read-only schema containing metadata about the catalog

## Bundles

<aside>
💡

**Summary**: We utilize DABs to manage all pipeline resources, including job orchestration, variables, alerts, dashboard, and secret scopes.

</aside>

We are using [Declarative Automation Bundles](https://docs.databricks.com/aws/en/dev-tools/bundles/) (formerly known as Databricks Asset Bundles) to enable source control and automated deployment of current jobs, alerts, and dashboards.

As DAB files are created and updated they need to be deployed to the appropriate target environment, which for feature branches will follow the steps below. For the `dev` and `main` branches we utilize a Github action for automated deployment of bundles through a continuous integration and delivery (CI/CD) process run automatically when a branch is merged in the repository, following processes developed by the OCDO Data Engineering team.

### Bundle Configuration

The [databricks.yml](https://docs.databricks.com/aws/en/dev-tools/bundles/settings) file is used to specify bundle configurations. Configurations decisions specific to our implementation include: 

- **permissions** - permissions are set for all resources within the bundle so that jobs will have correct permission following team standards
- **name_prefix** - For the development target, the branch name includes the user and git branch to distinguish across jobs set by the `name_prefix`.
    - Git branch names will not include “/” since that has created issues when creating job names that include this character.
- **source_linked_deployment** - see "Web Interface" section below

### Jobs

The files in `resources/jobs/` define and schedule bundle [jobs](https://docs.databricks.com/aws/en/dev-tools/bundles/resources#jobs), including weekly OMOP data refresh. Some guidelines for setting up jobs:

- **Naming** - We follow team naming standards for job names and set them for each target in the `databricks.yml` file. For the development target, the branch name includes the user and git branch to distinguish across jobs set by the `name_prefix`.
- **Tags** - we follow team tagging standards, which will include tags for:
    - Key: Function, Value: Transformation
    - Key: Transformation Jobs, Value: OMOP
- **Permissions** - we do not set permissions on a per-job basis. Instead, permissions are set in the databricks.yml file for all resources within the bundle so that jobs will have correct permission following team standards.
- **Run As** - all jobs will be set to run as a service principle, differing by workspace

Jobs we currently have defined are listed below, with links to the job in the production workspace:

| Name | Purpose | Schedule |
| --- | --- | --- |
| omop_schema_creation | Define all OMOP tables, columns with data types, primary and foreign keys, non-null constraints, and table and column comments. Based on OMOP standard [Data Definition Language (DDL)](https://github.com/OHDSI/CommonDataModel/tree/main/inst/ddl/5.4/spark). | With new version release, or as needed with schema updates |
| omop_custom_vocab_csv_to_table | Load custom vocabulary within CSV files within the bundle into Databricks tables | With new version release, or as needed with custom vocabulary updates |
| omop_vocabulary_refresh | Overwrite all OMOP vocabulary tables, including tables with only Athena vocabulary and tables with both Athena and custom vocabulary | With new version release, or as needed with vocabulary updates |
| omop_refresh_orchestration | All OMOP updates requred on a weekly basis: omop_table_refresh, omop_dqd, and refresh_dqd_dashboard | Weekly on Wednesdays at 2am Pacific Time |
| omop_table_refresh | Overwrites all non-vocabulary OMOP CDM main and intermediate tables then runs DQX validation checks. | Scheduled as part of omop_refresh_orchestration |
| dqd | Run OMOP Data Quality Dashboard (DQD) checks and save results | Scheduled as part of omop_refresh_orchestration |

### Deploying Bundles

Through our CI/CD process, implemented through a GitHub action within the repo, updated bundles are automatically deployed when PRs are merged to the `main` and `dev` branches. To deploy a bundle from another branch (e.g. for testing purposes before merging to `dev`), follow the instructions below based on the interface.

#### CLI

1. Install the Databricks CLI: https://docs.databricks.com/aws/en/dev-tools/cli/install
2. In a terminal window on your computer, navigate to the folder for the branch you want to deploy
3. Follow Databricks [authentication instructions](https://docs.databricks.com/aws/en/dev-tools/cli/authentication#oauth-user-to-machine-u2m-authentication) (e.g., `databricks auth login`). Enter your account id, which is your default profile for Databricks. This will open a browser window for the authentication. 
4. Once authenticated, run the [bundle command](https://docs.databricks.com/aws/en/dev-tools/cli/bundle-commands): `databricks bundle deploy` to deploy the bundle on your current path with the default profile (or specify another profile if desired).
    1. The default target will be the one indicated as `default: true` in `databricks.yml` (currently `develop` for `omop-cdm-v5.4`). If another target is desired, specify that with `--target <name>`.
    2. You can specific the profile to deploy the bundle as using: `--profile <profile name>`. 
5. Examine the messages that are printed to confirm the bundle has deployed successfully. If successfully deployed, all resources (i.e., jobs, alerts, dashboards) that are part of the bundle will be available in the workspace (`test` or `production`) associated with the deployed target. The naming of the job will be impacted by the `name_prefix`  for the target. For example, for a target of `develop`, this is currently set to include the user name and git branch name. The location where the files are deployed will be specified by the `root_path`.

#### Web Interface

Deployment of bundles can also be done through the Databricks web interface following the instructions here: https://docs.databricks.com/aws/en/dev-tools/bundles/workspace-deploy. This defaults to saving the bundle files in a location owned by the current user, not necessarily accessible to a service principle that may be designated to run the deployed jobs. To use the deployment path specified by `root_path`, in the `databricks.yml` file the `present` value for `source_linked_deployment` must to be set to `false` as shown below:

```yaml
targets:
  develop:
    presets:
      source_linked_deployment: false
```

### Updating Dashboards within Bundles

[Dashboards](https://docs.databricks.com/aws/en/dev-tools/bundles/resources#dashboards) can be included as a resource in a bundle to version control changes.

If a dashboard already exists as part of a bundle and you want to make updates to it as part of a feature development branch, from that feature branch deploy the bundle:

```sql
databricks bundle deploy
```

That will create the bundle resource in the test environment with the same specified as in the bundle `name_prefix` (e.g., `mgerber_update-dashboard_OMOP Data Quality Dashboard (DQD)`). You can then edit the dashboard using the Databricks web UI from that version. Once you make updates to the dashboard in the Databricks Web UI and want to save those changes to the `.lvdash.json` file within your bundle, in the CLI run:

```sql
databricks bundle generate dashboard --resource <resource_name> --force
```

To automatically update the local bundle to stay in sync with changes made in the UI use —watch:

```sql
databricks bundle generate dashboard --existing-id <dashboard-id> --force --watch
```

If you make changes to your bundle locally that impact the dashboard, you can update the dashboard within the Databricks UI by deploying the bundle. To overwrite the existing dashboard you may need to use `--force` :

```sql
databricks bundle deploy --force
```

If you have an existing dashboard that is not yet part of a bundle that you would like to move into a bundle, creating the `.lvdash.json` file that defines the dashboard and the `resources/<dashboard_name>.dashboard.yml` that defines the dashboard resource, in the CLI run:

```sql
databricks bundle generate dashboard --existing-id <dashboard_id> --bind
```

### Secret Scopes

A [secret_scopes](https://docs.databricks.com/aws/en/dev-tools/bundles/resources#secret_scopes) resource is used to manage permissions to secrets utilized in the bundle.

#### Binding a secret scope to a bundle

If a scope already exists and you want to bind it to bundle, first confirm it exists in the workspace:

```sql
databricks secrets list-scopes --profile <your profile for this workspace>
```

Once confirmed, bind the existing scope to the bundle resource scope using:

```sql
databricks bundle deployment bind <bundle-resource-key> <existing-resource-identifier> --target <target>
```

For the DQD scope in prod the command was:

```sql
databricks bundle deployment bind dqd_scope omop_dqd --target prod
```

### Alerts

[Alerts](https://docs.databricks.com/aws/en/dev-tools/bundles/resources#alerts) that are SQL Alert v2 can be defined through a bundle. We currently have the alerts below for OMOP:

| Name | Purpose | Schedule |
| --- | --- | --- |
| omop_dqx_alert_error | Alert to notify when the DQX checks indicate any errors from the most recent run of the checks for each OMOP table. | Weekly on Monday at 3pm Pacific Time |
| omop_dqx_alert_warn | Alert to notify when the DQX checks indicate any warnings from the most recent run of the checks for each OMOP table. | Weekly on Monday at 3pm Pacific Time |

### Variables

All variables used in the bundle are defined in `resources/variables/vars.yml`.

## ID Generation

<aside>
💡

**Summary**: We use the [xxhash64](https://docs.databricks.com/aws/en/sql/language-manual/functions/xxhash64) function to generate all OMOP ID columns to ensure consistency in these IDs with full data refreshes and compliance with integer datatype requirements. We will monitor for duplicate ID values.

</aside>

All of the OMOP CDM tables include ID columns to be used in identify unique records and joining between tables. The ID requirements/considerations include:

- Integer - The OMP CDM v5.4 requirements define all the ID columns as INTEGER type. While there don’t seem to be any formal limits on the size of this integer from the CDM, several other CDM implementors have encountered restrictions in the downstream use of the data that have necessitated limiting the size of this integer (e.g., 32 bit). The only integer data type that exists in Databricks is a 64-bit BIGINT, but maintaining values 32 bit values would ease conversion to an INTEGER data type if needed. Since there is currently no know data sharing needed with systems that cannot accept a BIGINT, limiting the size of the INTEGER is not prioritized. If we do share data with an institution that has database limitations requiring IDs to be in an INTEGER format, we will map the values as necessary.
- Unique
- Positive - for consistently with general best practices
- Persistence - ID values consistently corresponding to the same record with regular data refreshes to allow for consistent identification on the same records with re-running of queries over time. This is a requirement for the person_id but for the other IDs reduces other issues (e.g. inconsistency of ID references while the jobs updating the OMOP tables is in process).

The table below summarizes the methods of ID generation considered. Of these, we have used the [xxhash64](https://docs.databricks.com/aws/en/sql/language-manual/functions/xxhash64) function which returns a BIGINT 64-bit hash value of the arguments that can be positive or negative. We will take the absolute value ([abs](https://docs.databricks.com/aws/en/sql/language-manual/functions/abs)) of the values provided by the xxhash64 function to maintain positive values in our IDs, a general best practice. It is generated based on a combination of unique identifiers in the source data. For example, visit_occurrence_id will be generated based on a combination of a column indicating the visit data source (e.g., Epic Clarity) and the unique identifier from that source data (e.g., pat_enc in Epic Clarity). Hash functions return a deterministic value that will be consistent over time. Evaluation of the xxhash64 with abs function found that it returns all unique values based on the unique records identifiers in the Clarity data for visit (pat_enc_csn_id). As we implement this for each ID we will checks for duplicate IDs generated and created alerts to monitor for this on an ongoing basis.

| Method | Details | Limitations |
| --- | --- | --- |
| [xxhash64](https://docs.databricks.com/gcp/en/sql/language-manual/functions/xxhash64) | Hash function that creates a unique identifier based on the combination of several columns (e.g., Clarity pat_enc_csn_id). Returns a BIGINT 64-bit hash value that can be positive or negative. The value will be deterministic, so the same value will be returned from the same input. Similar hash methods has been used in other OMOP CDM implementations | May experience non-uniqueness in very large datasets, but can be monitored; BIGINT may need to be converted to an INT (the OMOP standard for this column) when sharing with certain external users |
| [hash](https://docs.databricks.com/aws/en/sql/language-manual/functions/hash) | Similar to xxhash64 but returns a BIGINT 32-bit hash value that can be positive or negative. | Returns non-unique values for visit_occurrence_id, and likely other IDs |
| [row_number](https://docs.databricks.com/aws/en/sql/language-manual/functions/row_number) | Assigns a unique, sequential number to each row based on defined ordering.  | Not persistent over time with table refreshes |
| Separate ID mapping table | Maintain a separate table that maps source data IDs to our OMOP IDs that only adds (does not remove or update) records so IDs are persistent | Added complexity of joins and tables to maintain |
| [GENERATED ALWAYS AS IDENTITY](https://docs.databricks.com/aws/en/delta/generated-columns?language=SQL) | Delta Lake identity columns are a type of generated column that assigns unique values for each record inserted into a table.  | Not persistent over time with table refreshes; Materialized views do not support identity columns (if those are utilized in the future) |

## Table Architecture

<aside>
💡

**Summary**: All OMOP tables are maintained as Delta tables utilizing features to support data quality and efficiency.

</aside>

### Constraints

Column constraints will include:

- informational primary key
- informational foreign key
- non-null

### Partitioning

Liquid clustering is enabled by default in Databricks and will adapt partitioning based on query patterns. We will rely on liquid clustering for optimization for now bit if we notice issues with query performance in the future we will consider explicit assignment of the [partitioned by](https://docs.databricks.com/aws/en/sql/language-manual/sql-ref-partition#partitioned-by) clause to optimize query performance for the columns most frequently used for partitioning data.

[ZORDER](https://docs.databricks.com/aws/en/delta/data-skipping#what-is-z-ordering) may also be utilized in the future.

## File Formats

<aside>
💡

**Summary**: OMOP transformations will be defined in .SQL files not in a notebook format.

</aside>

The files contains code used to generate and refresh the OMOP CDM tables will be in the .SQL format in most cases, though it may be in a .PY format as we utilize Python code. These will not utilize the Databricks Notebook feature to avoid the addition of comments at the top (“*-- Databricks notebook source*”) and between blocks (“*-- COMMAND ----------*”). While there are no immediate issues caused by our use of .SQL notebooks so far, this change may improve code linting and reduce incompatibility with other systems or as Databricks standards evolve.

## Testing

In the future integration tests will be implemented that run our table update jobs with standardized source data (potentially from `reference_systems.synthea_100k` or `reference_systems.synthea_1k`) and output to expected result tables to confirm proper functioning. Eventually will utilize a Github action to implement a CI/CD process run automatically when a pull request (PR) is opened, updated, and/or merged in the repository.

## Data Quality Monitoring

<aside>
💡

**Summary**: We use the OMOP [Data Quality Dashboard](https://github.com/OHDSI/DataQualityDashboard) (DQD) for standard OMOP checks and Python library [DQX](https://databrickslabs.github.io/dqx/) for binary (pass/fail) OMOP data quality monitoring to flag rows not meeting constraints on individual columns. 

</aside>

We currently use a combination of tools for data quality monitoring, including:

- OMOP [Data Quality Dashboard](https://github.com/OHDSI/DataQualityDashboard) to summarize the percentage of records meeting plausibility, conformance, and completeness standards, compared against defined thresholds
- [DQX](https://databrickslabs.github.io/dqx/) for binary (pass/fail) checks to flag rows not meeting constraints on individual columns

In the future we plan to also utilize:

- [data profiling](https://docs.databricks.com/aws/en/data-quality-monitoring/data-profiling) on each OMOP table with an associated dashboard that can be used for investigation of potential issues and additional alerts and metrics
- A custom Databricks dashboard for tracking of key metrics for weekly monitoring

### OMOP Data Quality Dashboard (DQD)

The [Data Quality Dashboard](https://github.com/OHDSI/DataQualityDashboard) (DQD) is utilized for standard OMOP data quality monitoring. This R package systematically runs the checks, evaluates the checks against some pre-specified threshold, and then communicates what was done in a transparent and easily understandable way. It summarizes the percentage of records meeting plausibility, conformance, and completeness standards.

Weekly these checks are refreshed after the OMOP data are refreshed as part of the "dqd" job and refresh of the "OMOP Data Quality Dashboard (DQD)" scheduled as part of the "omop_refresh_orchestration" job.

DQD includes 25 different check types (https://ohdsi.github.io/DataQualityDashboard/articles/CheckTypeDescriptions). 

These are defined at 3 levels:

- **Table-level** - evaluating the table at a high-level without reference to individual fields, or those that span multiple event tables
- **Field-level** - related to specific fields in a table
- **Concept-level** - related to individual concepts

These are also defined within 2 contexts:

- **Validation** -  alignment of data values with respect to relevant external benchmarks; validated against an accepted gold standard
- **Verification** - how data values match expectations with respect to metadata constraints, system assumptions, and local knowledge

These are defined within 3 categories:

- **Conformance** - compliance of the representation of data against internal or external formatting, relational, or computational definitions, including value, relational, and computational; do data values adhere to specified standards and formats?
- **Completeness** - frequencies of data attributes present in a data set *without reference to data values; are data values present?*
- **Plausibility** - believability or truthfulness of data values, including by uniquess, atemporal, and temporal; are data values believable?

### DQX

We utilize [DQX](https://databrickslabs.github.io/dqx/), a data quality framework for Apache Spark with a Python library that enables us to define, monitor, and address data quality issues. The checks can utilize pre-defined [row-level checks](https://databrickslabs.github.io/dqx/docs/reference/quality_checks/#row-level-checks-reference) applied to each row (e.g., `is_not_null_and_not_empty`, `is_in_list`) and [dataset-level checks](https://databrickslabs.github.io/dqx/docs/reference/quality_checks/#dataset-level-checks-reference) applied to group of rows (e.g., `is_unique`), and also custom defined [row-level](https://databrickslabs.github.io/dqx/docs/reference/quality_checks/#creating-custom-row-level-checks) and  [dataset-level](https://databrickslabs.github.io/dqx/docs/reference/quality_checks/#creating-custom-dataset-level-checks) checks as needed. In `.yml` files we will define the checks to apply for each table by column, in a `.py` file will execute these checks, and a Databricks alert will be used for notification of issues.

1. **Define Checks**: A YAML file for each OMOP table defining the checks to be run on on that table, e.g. `models/person/person_checks.yml`

```yaml
- criticality: warn
  check:
    function: is_not_null_and_not_empty
    arguments:
      column: person_id
- criticality: warn
  check:
    function: is_unique
    arguments:
      columns: 
      - person_id
```

1. **Run Checks**: A Python script will be run at the end of the `omop_table_refresh` job that can applies the checks defined in the YAML files for each OMOP table 
    - The `apply_checks_by_metadata_and_split` function will be used to annotate invalid records as additional columns (`_warning` and `_error`)  and save the quarantined records in a table for data quality monitoring (e.g. `curated_omop.omop_monitoring.person_quarantine`)
    - `DQMetricsObserver` will also be used to create summary metrics, saving the resulting summary metrics to the table `curated_omop.omop_monitoring.dqx_metrics`
2. **Alert on Checks**: The final step in the `omop_table_refresh` job will be a SQL alert that checks `curated_omop.omop_monitoring.dqx_metrics` for each unique OMOP table (`catalog`. `schema`.`table`) by the most recent `monitoring_timestamp` for non-zero values in the `error_row_count` or `warning_row_count` columns.

### Databricks Data Profiling (Future)

For OMOP tables, we plan to enable the Databricks [data profiling](https://docs.databricks.com/aws/en/data-quality-monitoring/data-profiling) feature (part of [data quality monitoring](https://docs.databricks.com/aws/en/data-quality-monitoring/)), which will create `<table>_profile_metrics` and `<table>_drift_metrics` tables within the schema `omop_monitoring`, and a dashboard based on these tables for monitoring related metrics. These dashboard can be used for investigation of potential issues and additional alerts and metrics for the individual OMOP tables.

### Summary Dashboard (Future)

We also plan to create a customized central dashboard within Databricks to monitor key metrics across all the OMOP tables that would be checked on a weekly basis after table updates. If that central dashboard indicates an issue, we will then dig into the dashboards for individual tables to better understand the issues, but otherwise we will not be monitoring the dashboards for the individual tables on a regular basis due to the large number of them.

## Table Refresh

<aside>
💡

**Summary**: [INSERT OVERWRITE](https://docs.databricks.com/gcp/en/sql/language-manual/sql-ref-syntax-dml-insert-into) is used to fully refresh all tables.

</aside>

[INSERT OVERWRITE](https://docs.databricks.com/gcp/en/sql/language-manual/sql-ref-syntax-dml-insert-into) is used to fully refresh all tables, through jobs run on a weekly basis for all non-vocabulary tables and jobs run as-needed for vocabulary tables. This method maintains the table properties (table and column comments, constraints, data types) and the table history while refreshing all data in the table.

## Refresh Rollback Process

<aside>
💡

**Summary**: [RESTORE TABLE](https://docs.databricks.com/aws/en/sql/language-manual/delta-restore) is used when rollback is needed, up to a period of 30 days.

</aside>

If an issue with a refresh of the OMOP tables is identified, we may use the [RESTORE TABLE](https://docs.databricks.com/aws/en/sql/language-manual/delta-restore) functionality to restore to a previous version of the data for use while the issue is being addressed. The table properties for all OMOP tables will be set as follow to allow for rollback up to 30 days: 

```
TBLPROPERTIES (
	'delta.deletedFileRetentionDuration' = 'interval 30 days'
	,'delta.logRetentionDuration' = 'interval 30 days'
)
```

## Data Archiving

<aside>
💡

**Summary**: Data archiving beyond the 30 day rollback period is not currently supported.

</aside>

Data used by downstream users in  `curated_omop` will update on a weekly basis.  We may  decide to archive a version of the data before a major release. Otherwise, we do not plan to archive the state of the OMOP tables at a certain point in time. If researchers need a record of the data at the time of their analyses, that will need to be archived separately. If this plan becomes incompatible with key user needs, we will re-evaluate.

## JDBC Connection

<aside>
💡

**Summary**: A token managed as a secret is needed for establishing the JDBC connection required for several OHDSI R packages.

</aside>

We need to set up a JDBC connection to the Databricks unity catalog when running OHDSI packages that utilize the `DatabaseConnector` R package, including `DataQualityDashboard` and `Achilles`.

### Connection String

The JDBC connection string can be determined, with our without reference to a specific catalog, using the Python code: <TBD>. Run this from the cluster and environment for which you need the connection string. Set the `default_catalog` to the catalog that will be accessed.

## Communication

### With Users (Future)

We plan use a Slack channel and email list to communicate version released, and data changes, and timely data issues to OMOP data users.

### With Developers

To communicate issues to our internal team, we have set up Databricks to notify on job failure or alert trigger to a shared email invox. Since tha email does not have an associated Databricks account, we have set up a [notification destination](https://docs.databricks.com/aws/en/admin/workspace-settings/notification-destinations) to be able to send emails there.

## Data Dictionary

All tables and columns will have an informative defined comment that will be accessible from the Databricks Unity Catalog and, in the future, through a view of that metadata embedded in a documentation website, accessible to potential users to determine if the data meets their needs before getting access to Databricks.  

## Code Formatting and Standards Enforcement

SQL code should follow the SQL style guideline ("docs/sql_style_guideline.md"). As part of the CI/CD process, a GitHub Action using [SQLAutoFormatter](https://github.com/marketplace/actions/sqlautoformatter) runs an automated code formatter to ensure the code complies with these standards.

## AI Tooling

We utilize [Genie Code](https://www.databricks.com/product/genie/code) for assistance in OMOP development work. In the `skills/` folder we have defined skills through Markdown (.md) files to enable better AI support for OMOP development. To utilize these skill within your Databricks workspace, in the `/Workspace/Users/<your_user_email>/.assistant/skills/` folder, copy or clone the repo (or just the `skills/` folder).

## Lakeflow Declarative Pipelines & Materialized Views

<aside>
💡

**Summary**: We considered using Lakeflow Declarative Pipelines and materialized views but have decided not to utilize these features at this time. 

</aside>

[Lakeflow Spark Declarative Pipelines](https://docs.databricks.com/aws/en/ldp/) (LSDP) use [declarative data processing](https://docs.databricks.com/aws/en/data-engineering/procedural-vs-declarative), focusing on what needs to be achieved and leaving the underlying system to determine the best way to execute the task. Only a subset of data types can be created and updated through LSDPs including materialized views, temporary views, and streaming tables. 

The LDSPs could be used to implement logic to create materialized views for all OMOP final data defined in the OMOP CDM v5.4 requirements and data created in the process of generating that final data, organized based on the Schema Organization defined above. On a weekly basis, these materialized views would be refreshed in sequence based on dependences through a LSDP.

LSDP built-in algorithms calculate the table updates needed based on the time of refresh utilizing either a full or incremental refresh method depending on what is possible based on source tables, though this is not explicitly controlled. As Change Data Feed (CDF) features are implemented in upstream source tables, the incremental updates will be possible and automatically utilized.

### Contraints

[Table and column constraints](https://docs.databricks.com/aws/en/sql/language-manual/sql-ref-syntax-ddl-create-materialized-view) could be applied to the materialized views to ensure data quality standards are met and data that do not meet these standardize are not materialized for access by downstream users. These include:

- informational primary key
- informational foreign key
- non-null
- unique

### Expectations

[Expectations](https://docs.databricks.com/aws/en/ldp/expectations) apply quality constraints that validate data as it flows through a pipeline. These will be implemented as defined in the relevant table requirements markdown document and may include:

- valid integer and date ranges
- valid categorical options

Violations of defined expectations can trigger a warning, dropping the relevant row, or failure of the pipeline.
