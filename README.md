# fhcc-omop-template

## Purpose

This repo provides an example of data and analytics engineering best practices for development of an OMOP CDM instance on Databricks.

Add a short description of your OMOP CDM instance here, including:

- What data is transformed
- What CDM version is used
- Information about the data system this OMOP instance runs on
- The team developing OMOP

## Geting Started
Our team processes for contributing are outlined in the `docs/` folder. You could also add this to an internal team page on an application like Notion or Confluence.

Information for OMOP CDM users will be available on the [your website]().

## Repository Structure

```
📂 fhcc-omop-template
├── 📁 .github
|   ├── 📄 pull_request_template.md                   # Default template for all pull requests
|   ├── 📂 ISSUE_TEMPLATE                             # Templates for issues
|   |   ├── 📄 request.md                             # Template for issue requesting new data or features
│   │   └── 📃 bug-report.md                          # Template for reporting bugs
|   ├── 📂 workflows                                  # Define GitHub Actions
|   |   ├── 📄 cicd.yml                               # Continuous Integration/Continuous Deliver (CI/CD) to deploy bundle updates to Databricks
│   │   └── 📃 sql-formatting.yml                     # Automatically update SQL code formatting in line with standards
├── 📁 data_checks                                    # Summary-level quality checks by table
├── 📁 models                         
│   ├── 📂 table_name                                 # 1 folder per CDM table
│   │   ├── 📄 table_requirements.md                  # Requirements the data transformation should comply with
|   |   ├── 📄 table_comments.sql                     # Set table and columns comments
|   |   ├── 📄 table_checks.yml                       # DQX checks
│   │   └── 📃 populate_table.sql                     # Data transformation to create and overwrite the table
|   ├── 📂 table_creation                             # Creates empty tables, defines constraints and foreign and primary keys
|   |   ├── 📄 table_creation.sql                     # Data definition language (DDL)
|   |   ├── 📄 not_null_constraints.sql               
|   |   ├── 📄 primary_key_constraints.sql            
|   |   ├── 📄 foreign_key_constraints.sql            
│   │   └── 📃 intermediate_table_creation.sql        # Defines intermediate tables used in creation of CDM tables but not part of the CDM
│   └── 📂 vocabulary_concept                         # Creates and populate vocabulary tables
|       ├── 📄 vocabulary_concepts_custom_updates.sql # Update vocabulary tables based on both Athena and custom vocabulary
│       └── 📃 vocabulary_concepts_athena_only.sql    # Updates vocabulary tables based only on Athena
├── 📁 monitoring                                     # Implements DQX checks
|   ├── 📄 monitoring_table_creation.sql              # Creates the tables to hold monitoring results
|   ├── 📄 omop_dqx_monitoring.py                     # Runs DQX checks for all tables
|   └── 📄 omop_dqx_monitoring_tables.yml             # Lists the files where the DQX checks to run for each table are saved
├── 📁 resources                                      # Defines the resources that are part of the bundle. Only folders for the relevant resources are included.
│   ├── 📂 alerts                                     # Contains .alerts.yml files defining alerts
│   ├── 📂 jobs                                       # Contains .job.yml files defining job
│   ├── 📂 variables                                  # Contains one vars.yml file defining all variables used in the bundle
│   ├── 📂 dashboard                                  # Contains .dashboard.yml files defining dashboard resources
│   └── 📂 secret_scopes                              # .secret_scope.yml defining the scopes for secrets utilized in the bundle
├── 📁 src
│   └── 📂 catalog                                    # Unity Catalog catalog setup and permissions
├── 📁 templates
|   ├── 📄 OMOP Explanatory Notebook Template.md      # Template for explanatory analysis notebooks to inform data transformation decisions
|   └── 📄 Table Requirements Template.md             # Template for models/table_name/table_requirements.md
├── 📁 skills                                         # Skills utilized by AI agents
│   ├── 📂 populate_new_omop_table                    # Instructions for populating a new CDM table
│   │   └── 📃 skill.md
│   └── 📂 add_task                                   # Instructions for adding a task to a bundle job for populating a new CDM table
│       └── 📃 skill.md
├── 📁 docs                                           # Team development workflows 
├── 📃 .gitignore
├── 📃 CODEOWNERS                                     # Defines individuals and teams responsible for the code in this repository
├── 📃 databricks.yml                                 # Databricks asset bundle definition
└── 📄 README.md 
```


## Contributing
Our team development workflow is outlined in the [docs] folder, including best practices for code review and our code style guidelines.

If you have found a bug or errors (in code or how you believe the data is mapped), please file an issue on this repo.

## Contacts
- Megan Stachura, Analytics Engineer, lead OMOP developer (mstachur@fredhutch.org)
- Monica Gerber, Data Science Manager, OMOP product manager & developer (mgerber@fredhutch.org)
