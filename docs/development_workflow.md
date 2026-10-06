# OMOP Development Workflow

This document outlines the human process that we will follow for developing our initial implementation of the OMOP CDM.

We are using the [git flow](https://nvie.com/posts/a-successful-git-branching-model/#release-branches) branching model for our OMOP development workflow. We will use the following conventions for naming branches:

| **Branch Name** | **Unity Catalog** | **Description** |
| --- | --- | --- |
| main | curated_omop | Production code only |
| dev | curated_omop_test | Development branch |
| feature-*shortname* | curated_omop_test | Any new feature development that will be merged to the dev branch, including updates to requirements documentation |
| hotfix-*shortname* | curated_omop_test | Urgent bug fixes, can be merged to production |
| bugfix-*shortname* | curated_omop_test | Non-urgent bug fixes, are merged to development or release branches |

### Creating a New OMOP Table

---

*Note: throughout steps 1-5 we should consult with Nemesis during our weekly Tuesday meeting.* 

**Documenting Table Requirements**

1. Familiarize yourself with OMOP format, conventions, and vocabulary.
    1. Read the [OMOP CDM documentation](https://ohdsi.github.io/CommonDataModel/cdm54.html) for the table. What upstream tables will be needed to create this table? What are the foreign keys?
    2. Review the [Themis conventions](https://ohdsi.github.io/Themis/index.html) for this table. Do you anticipate that we will be able to follow these conventions?
    3. Which standardized vocabularies will be used in this table? Are there any Fred Hutch or Epic-specific vocabularies that need to be mapped? 
2. Read through examples form other institutions and begin to put together a list of Epic tables that you may need.
    1. Look at the code that Corewell and Columbia have posted on Epic forums. Also take a look at the [Janssen CDM Documentation](https://ohdsi.github.io/ETL-LambdaBuilder/) website. What decisions did they need to make that aren’t covered by the OMOP general conventions and Themis repository?
        1. Corewell: 
            1. [https://userweb.epic.com/Thread/139889/OMOP-The-Final-Frontier](https://userweb.epic.com/Thread/139889/OMOP-The-Final-Frontier)
            2. Corewell update: https://userweb.epic.com/Thread/147477/OMOP-VI-The-Undiscovered-Caboodle/
        2. Columbia: [https://userweb.epic.com/Thread/99407/OMOP-All-of-Us-Master-OMOP-Thread/?reply=589641](https://userweb.epic.com/Thread/99407/OMOP-All-of-Us-Master-OMOP-Thread/?reply=589641)
    2. Compile a list of Epic tables relevant to this OMOP table. Are all of these tables currently ingested and available in Databricks?
3. Conduct exploratory data analysis and data profiling of source tables using a Databricks notebook. Add all your questions/thoughts/checks in a notebook for yourself. Make sure there is enough guidance and comments so that future you can come back to this as needed.
    1. For potential source columns, look at:
        1. Completeness (percentage of NULL/blank values)
        2. Distinctness/uniqueness (e.g, how many unique pat_ids exist? other unique ids?)
        3. Value distributions, if relevant (e.g. date ranges)
        4. Other checks (to be added)
    2. Are vocabularies easily mapped from the source data?
4. Curate your exploratory analysis in an “[explanatory data analysis](https://vdsbook.com/05-data_viz#exploratory-and-explanatory-data-analysis)” notebook (use `templates/OMOP Explanatory Notebook Template.md`). Outline data profiling and checks that will be important for colleagues to review and will inform the table requirements markdown doc. Make sure colleagues can follow along — add informative comments in Markdown. This should be drafted on a branch in the omop-vocab-exploration repo. 
5. Draft the table requirements document(use `templates/Table Requirements Template.md`) on a branch in the omop-cdm-5.4 repo (in Databricks test environment).
6. Open a draft PR for the explanatory analysis and requirements doc early so other teammates can follow along if needed.
7. When ready, review explanatory analysis and requirements doc with teammates in the OMOP check-in meeting. Collect feedback, revise, open the PR. 

**Writing Transformation Code**

1. Once the requirements have been settled on, SQL transformation code development begins following the `docs/OMOP Technical Implementation.md` guide and our `docs/Team Coding Standards.md`. This always takes place in the Databricks test environment. 
2. The developer may use a schema in `curated_omop_test` to conduct adhoc checks/profiling on transformation code.
3. Code is always reviewed by at least one reviewer from the "omop" Github team before it it merged from a feature branch to the dev branch. The review will focus on checking that the code confirms to the tables requirements and or coding standards.
    1. A secondary review may be asked for from a member of the data engineering team if changes are made to the `resources` folder.

### OMOP Release Process

---

After all features and/or non-urgent bug fixes have been reviewed and merged to the dev branch, a release branch is created. At this time, we use the release branch to:

- Updates to metadata or changes or last-minute “dotting of i’s and crossing t’s” to documentation
- Minor bug fixes
- Additional testing?

At this time, the Data Science team is able to use the release branch to inform updates to:

- The CARDS website documentation
- Any other downstream projects that may be impacted

Release notes are written and prepared for the CARDS website and GitHub Releases feature.

A checklist will be created for reviewers for reviewing release branches to ensure that the process is more streamlined and transparent.

When the release branch is ready and all review checklists are completed, it is merged to main  and becomes production code. The release is coordinated with other repos containing documentation and release notes (e.g. CARDS website). The release notes are also tagged and published using GitHub Releases.
