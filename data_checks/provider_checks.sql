-- Databricks notebook source
-- MAGIC %md
-- MAGIC # provider

-- COMMAND ----------

USE CATALOG IDENTIFIER('curated_omop_test');
USE SCHEMA IDENTIFIER('omop');

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Look at provider data

-- COMMAND ----------

select *
from provider
order by random()

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Check DQX results

-- COMMAND ----------

select *
from omop_monitoring.provider_quarantine

-- COMMAND ----------

select *
from curated_omop_test.omop_monitoring.dqx_metrics
where table = 'provider'
order by monitoring_timestamp desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC No issues found by the DQX checks for this table.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## prov_type

-- COMMAND ----------

SELECT
  prov_type_concept_id,
  prov_type_source_concept_id,
  prov_type_source_value,
  concept.concept_name,
  COUNT(*) AS provider_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS provider_pct
FROM provider
LEFT JOIN concept
  on provider.prov_type_concept_id = concept.concept_id
GROUP BY 1,2,3,4
ORDER BY provider_count DESC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC The most common provider types are in line with expectations and mapped as expected.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Gender

-- COMMAND ----------

SELECT
  gender_concept_id,
  gender_source_value,
  gender_source_concept_id,
  concept.concept_name,
  COUNT(*) AS provider_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS provider_pct
FROM provider
LEFT JOIN concept
  on provider.gender_concept_id = concept.concept_id
GROUP BY 1,2,3,4
ORDER BY provider_count DESC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Gender is mapped as expected and proportions are in line with expectations.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Duplicate provider_id

-- COMMAND ----------

SELECT
  provider_id,
  COUNT(*) AS duplicate_count
FROM provider
GROUP BY provider_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC

-- COMMAND ----------

select *
from provider
where provider_id in (
  SELECT provider_id
  FROM provider
  GROUP BY provider_id
  HAVING COUNT(*) > 1
)
order by provider_id

-- COMMAND ----------

-- MAGIC %md
-- MAGIC No duplicate provider_id, as expected.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## NULL provider_id

-- COMMAND ----------

SELECT *
FROM provider
WHERE provider_id IS NULL

-- COMMAND ----------

-- MAGIC %md
-- MAGIC No NULL provider_id as expected.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## test accounts
-- MAGIC See if there are any remaining providers that represent test accounts

-- COMMAND ----------

select care_site_name, provider_name
from provider
left join care_site
    on provider.care_site_id = care_site.care_site_id 
where provider_name ilike '%test%'
order by provider_name

-- COMMAND ----------

-- MAGIC %md
-- MAGIC There are still a small number of providers that include "test" in the name but not many with the same patterns and it is not completely clear these are not true providers just with a name containing "test".
