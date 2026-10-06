# OMOP Explanatory Notebook Template

## Resources

### OHDSI

*Links to data dictionary, OHDSI ETL guides, forum discussions, THEMIS, etc.*

*Add links to standard vocabularies used in OMOP for this table. Add references to manuscripts, articles, or webpages that may help with understanding the vocabulary.*

- CDM 5.4 description: [https://ohdsi.github.io/CommonDataModel/cdm54.html](https://ohdsi.github.io/CommonDataModel/cdm54.html#procedure_occurrence)
- THEMIS conventions: [https://ohdsi.github.io/Themis](https://ohdsi.github.io/Themis)
- Data Model Conventions: [https://ohdsi.github.io/CommonDataModel/dataModelConventions.html](https://ohdsi.github.io/CommonDataModel/dataModelConventions.html)
- Oncology ETL guide:  [https://github.com/OHDSI/OncologyWG/wiki/OnRamp](https://urldefense.com/v3/__https://github.com/OHDSI/OncologyWG/wiki/OnRamp__;!!GuAItXPztq0!hcQzVOLWauE9aT-t5NcOLG1pmbKg37VirmO0sWu_Yr0wyLZocrwvZL2-Kz6YJUxGn_ycNRuXow-cM0_NKb90qTfN4Yi_YHI$)

### Source/Epic Documentation

*Links to data model training or other resources on the Epic website*

- Epic Clarity Data Dictionary: [https://datahandbook.epic.com/ClarityDictionary](https://datahandbook.epic.com/ClarityDictionary)

### Code examples

*Links to Corewell or other example code referenced*

- Corewell: [https://userweb.epic.com/Thread/147477/OMOP-VI-The-Undiscovered-Caboodle/](https://userweb.epic.com/Thread/147477/OMOP-VI-The-Undiscovered-Caboodle/)
- Columbia: [https://userweb.epic.com/Thread/99407/OMOP-All-of-Us-Master-OMOP-Thread/?reply=589641](https://userweb.epic.com/Thread/99407/OMOP-All-of-Us-Master-OMOP-Thread/?reply=589641)
- Janssen CDM documentation: [https://ohdsi.github.io/ETL-LambdaBuilder/$0](https://ohdsi.github.io/ETL-LambdaBuilder/$0)

## Questions

*Outline main questions you need to answer in order to create the table.*

- Vocabulary
    - What source table/columns are needed for mapping the vocabulary?
    - What is the number and percentage of observations that will be unmapped?
    - What questions do you have for the team about how the source vocabulary is used and/or how to map it to OMOP standard concepts?
- Which source table(s) contain the data needed for this table? Does it need to be filtered?
    - Which columns or combination of columns will be used to create the OMOP table columns?
    - What is the data quality of the source columns? Explore NULLs, date ranges, etc.
    - If source data is spread across multiple columns, what is your proposed strategy for combining data that maintains preciseness and completeness of the data?

## Tables needed for mapping

*Add table names that will be used in the transformation from source to OMOP. This will be used to populate the table requirements markdown file. Add tables that could be used for future additions to our OMOP instance, even if we’re not doing the transformation now.*

### Patient-level data

*Fact tables*

### Reference data

*Dim tables* 

## Analysis

### Add headers for each chunk/type of questions

- State question/inquiry
- Add code block
- State conclusion/finding

*If many code chunks are used to get at one over-arching question, add text explaining the conclusion or recommendation.* 

## Vocabulary

*Add code chunks that produce output data for vocabulary mapping.*
