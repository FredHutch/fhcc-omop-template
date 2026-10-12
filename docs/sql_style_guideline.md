# SQL style guideline

# Overview

We plan to follow the standards detailed below for the SQL code contributed to the OMOP ETL GitHub repo. These are based on legible SQL standards, particularly [https://boringml.com/docs/languages/sql/legible-sql/](https://boringml.com/docs/languages/sql/legible-sql/).

Since this SQL will be run within the Databricks workspace, we will utilize Databricks SQL (similar to Spark SQL): [https://docs.databricks.com/aws/en/sql/language-manual/](https://docs.databricks.com/aws/en/sql/language-manual/)

# Automated Formatting

We have identified two main options for automatically updating SQL queries within Databricks/GitHub to meet the standards defined within this page, aside from manual updating.

## Databricks

Databricks can format queries to automatically follow many of the standards defined below. The settings for formatting SQL can be defined through a file saved within each individual’s Databricks workspace ([https://docs.databricks.com/aws/en/sql/user/sql-editor/custom-format](https://docs.databricks.com/aws/en/sql/user/sql-editor/custom-format))

To format a SQL query within the SQL Editor from the menu (three vertical dots) select Edit > Format Query.

To format a query within a notebook, from the menu for the cell (three vertical dots) select Format SQL.

To update any of the auto-formatting settings, open Developer Settings menu. To be consistent with the formatting guidelines below, update the settings to be consistent with those shown in the image below.

## GitHub Actions

[GitHub Actions](https://docs.github.com/en/actions) can be used automatically to format SQL code with pull requests. Since, there is added complexity when doing this within the notebook (IPYNB) format, when saving notebooks with SQL code a .SQL format is preferrer. This format can be selected under File > Notebook format > Source (.scala, .py, .sql, .r). This can also be set as the default file format within the developer settings.

- [https://github.com/Matts966/zetasql-formatter](https://github.com/Matts966/zetasql-formatter), [https://github.com/marketplace/actions/sqlautoformatter](https://github.com/marketplace/actions/sqlautoformatter)
    - I got this working as GitHub action in a test repo: [https://github.com/mstachur/sql-format-testing/blob/main/.github/workflows/sql-formatting.yml](https://github.com/mstachur/sql-format-testing/blob/main/.github/workflows/sql-formatting.yml). It took some trial and error to get the permissions to work, but it worked when I did not define them in the YML file explicity but instead set them at the repo level under Settings > Actions > General > Workflow permissions > Read and write permissions > Save

If in the future we would like to attempt formatting SQL code within a Jupyter Notebook, the references below may be helpful:

- [https://github.com/flyersworder/sqlnbfmt](https://github.com/flyersworder/sqlnbfmt), [https://medium.com/@yeqing_40735/automating-sql-query-standardization-in-jupyter-notebooks-with-sqlnbfmt-and-pre-commit-hook-35367a174228](https://medium.com/@yeqing_40735/automating-sql-query-standardization-in-jupyter-notebooks-with-sqlnbfmt-and-pre-commit-hook-35367a174228) - works with Jupyter Notebook but limited customization options and no examples of incorporating it into a GitHub Action, which I have not gotten to successfully run

Other available libraries for formatting SQL code include:

- [https://github.com/sql-formatter-org/sql-formatter](https://github.com/sql-formatter-org/sql-formatter)
- [https://github.com/sqlfluff/sqlfluff](https://github.com/sqlfluff/sqlfluff)

# SQL Standards

- Make all declarative keywords their own new line
    
    ```sql
    SELECT pat_id
    FROM patient
    WHERE pat_name is not NULL
    ```
    
    rather than
    
    ```sql
    SELECT pat_id FROM patient WHERE pat_name is not NULL
    ```
    
- Make all declarative statements and database functions uppercase and table names and columns lowercase so it’s easier to distinguish between these in the text and there is consistent capitalization within these categories
    
    ```sql
    SELECT pat_id
    FROM patient
    WHERE pat_name is not NULL
    ```
    
    rather than
    
    ```sql
    select pat_id
    from PATIENT
    where pat_name is not NULL
    ```
    
- Use indentation where appropriate, e.g., for sub-queries, sub-components of a declarative statement, or continuation of a statement on a new line
    
    ```sql
    SELECT pat_id
    	, pat_name
    	, birth_date
    FROM patient P
    LEFT JOIN patient_3 P3
    	ON P.pat_id = P3.pat_id
    WHERE pat_name is not NULL
    	AND P3.IS_TEST_PAT_YN != 'Y'
    ```
    
    rather than
    
    ```sql
    SELECT pat_id
    , pat_name
    , birth_date
    FROM patient P
    LEFT JOIN patient_3 P3
    ON P.pat_id = P3.pat_id
    WHERE pat_name is not NULL
    AND P3.IS_TEST_PAT_YN != 'Y'
    ```
    
- Include informative comments
    
    ```sql
    -- Get data for all patients where the patient name is not null
    SELECT pat_id
    FROM patient
    WHERE pat_name is not NULL -- Don't want to include patients with NULL name
    
    /* This is a 
    multiline
    comment */
    ```
    
- List all fields included rather than using *, so it is clear what columns are included in the result
    
    ```sql
    SELECT pat_id
    	, pat_name
    	, birth_date
    FROM patient
    ```
    
    rather than
    
    ```sql
    SELECT *
    FROM patient
    ```
    
- A Common Table Expressions (CTE) is a temporary result set that is defined using a `WITH` statement, is named and referenced by that name potentially multiple times. Similarly subqueries allow you to run multiple select statements within one query, but are nested within other clauses and are only used once. Sub-queries can be helpful for very sort query text only needing to be referenced once, but if they get long can be difficult to read. Avoid use excessive numbers of sub-queries; use CTEs instead where relevant, but also not excessive numbers of those in one query; create new tables when needed to avoid lots of sub-queries or CTEs that could make the query difficult to understand
    
    ```sql
    WITH patients_real AS (
    	SELECT pat_id
    	, pat_name
    	, birth_date
    	FROM patient P
    	LEFT JOIN patient_3 p3
    		ON P.pat_id = p3.pat_id
    	WHERE pat_name is not NULL
    		AND p3.is_test_pat_yn != 'Y'
    )
    
    SELECT p.pat_id
    	, p.pat_name
    	, p.birth_date
    	, ii.identity_type
    FROM patients_real p
    LEFT JOIN identy_id ii
    	ON p.pat_id = ii.pat_id
    ```
    
    rather
    
    ```sql
    SELECT p.pat_id
    	, p.pat_name
    	, p.birth_date
    	, ii.identity_type
    FROM (	
    			SELECT pat_id
    				, pat_name
    				, birth_date
    				FROM patient P
    				LEFT JOIN patient_3 p3
    					ON P.pat_id = p3.pat_id
    				WHERE pat_name is not NULL
    					AND p3.is_test_pat_yn != 'Y'
    			 ) AS p
    LEFT JOIN identy_id ii
    	ON p.pat_id = ii.pat_id
    ```
    
- Use concise but informative table aliases in joins
    
    ```sql
    SELECT pat_id
    FROM patient p
    LEFT JOIN patient_3 p3
    	ON p.pat_id = p3.pat_id
    ```
    
- Comma placement - do we want to have leading or trailing??? @Megan Stachura tends to prefer leading to be able to comment out a line with it’s comma included but this format is a bit less readable
    
    ```sql
    SELECT pat_id
    	, pat_name
    	, birth_date
    FROM patient P
    LEFT JOIN patient_3 P3
    	ON P.pat_id = P3.pat_id
    WHERE pat_name is not NULL
    	AND P3.IS_TEST_PAT_YN != 'Y'
    ```
    
    rather than
    
    ```sql
    SELECT pat_id,
    	pat_name,
    	birth_date,
    FROM patient P
    LEFT JOIN patient_3 P3
    	ON P.pat_id = P3.pat_id
    WHERE pat_name is not NULL
    	AND P3.IS_TEST_PAT_YN != 'Y'
    ```
    
- In table and column names use underscores (_) to separate words, all in lower case
    
    ```sql
    pat_name, birth_date
    ```
    
    rather than
    
    ```sql
    patName, birthDate
    ```
    
- Limit lines to 80 characters for readabilityTo be added later
