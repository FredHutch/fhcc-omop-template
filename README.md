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
├── 📁 alerts                         # Example table-level alert
├── 📁 data_checks                    # Example summary-level quality checks
├── 📁 models                         
│   ├── 📂 table-name                 # 1 folder per CDM table
│   │   ├── 📄 table-requirements.md
|   |   ├── 📄 table-comments.sql
|   |   ├── 📄 table_checks.yml
│   │   └── 📃 populate_table.sql
|   ├── 📂 table_creation             # creates empty tables and constraints 
│   └── 📂 vocabulary_concept         # creates and populate vocabulary tables
├── 📁 monitoring
├── 📁 models 
├── 📁 resources
├── 📁 src 
├── 📃 .gitignore
├── 📃 CODEOWNERS
└── 📄 README.md 
```


## Contributing
Our team development workflow is outlined in the [docs] page, including best practices for code review and our code style guidelines.

If you have found a bug or erros (in code or how you belive the data is mapped), please file an issue on this repo.

## Contacts
- Megan Stachura, Analytics Engineer, lead OMOP developer (mstachur@fredhutch.org)
- Monica Gerber, Data Science Manager, OMOP product manager & developer (mgerber@fredhutch.org)