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
-- MAGIC ## Null and 0 counts by column

-- COMMAND ----------

SELECT
  COUNT(*) AS total_rows,

  -- provider_id
  ROUND(SUM(CASE WHEN provider_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS provider_id_null_pct,

  -- provider_name
  ROUND(SUM(CASE WHEN provider_name IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS provider_name_null_pct,

  -- npi
  ROUND(SUM(CASE WHEN npi IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS npi_null_pct,

  -- dea
  ROUND(SUM(CASE WHEN dea IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS dea_null_pct,

  -- specialty_concept_id
  ROUND(SUM(CASE WHEN specialty_concept_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS specialty_concept_id_null_pct,
  ROUND(SUM(CASE WHEN specialty_concept_id = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS specialty_concept_id_zero_pct,

  -- care_site_id
  ROUND(SUM(CASE WHEN care_site_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS care_site_id_null_pct,
  ROUND(SUM(CASE WHEN care_site_id = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS care_site_id_zero_pct,

  -- year_of_birth
  ROUND(SUM(CASE WHEN year_of_birth IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS year_of_birth_null_pct,

  -- gender_concept_id
  ROUND(SUM(CASE WHEN gender_concept_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS gender_concept_id_null_pct,
  ROUND(SUM(CASE WHEN gender_concept_id = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS gender_concept_id_zero_pct,

  -- provider_source_value
  ROUND(SUM(CASE WHEN provider_source_value IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS provider_source_value_null_pct,

  -- specialty_source_value
  ROUND(SUM(CASE WHEN specialty_source_value IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS specialty_source_value_null_pct,

  -- specialty_source_concept_id
  ROUND(SUM(CASE WHEN specialty_source_concept_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS specialty_source_concept_id_null_pct,
  ROUND(SUM(CASE WHEN specialty_source_concept_id = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS specialty_source_concept_id_zero_pct,

  -- gender_source_value
  ROUND(SUM(CASE WHEN gender_source_value IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS gender_source_value_null_pct,

  -- gender_source_concept_id
  ROUND(SUM(CASE WHEN gender_source_concept_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS gender_source_concept_id_null_pct,
  ROUND(SUM(CASE WHEN gender_source_concept_id = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS gender_source_concept_id_zero_pct,

  -- prov_type_concept_id
  ROUND(SUM(CASE WHEN prov_type_concept_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS prov_type_concept_id_null_pct,
  ROUND(SUM(CASE WHEN prov_type_concept_id = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS prov_type_concept_id_zero_pct,

  -- prov_type_source_value
  ROUND(SUM(CASE WHEN prov_type_source_value IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS prov_type_source_value_null_pct,

  -- prov_type_source_concept_id
  ROUND(SUM(CASE WHEN prov_type_source_concept_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS prov_type_source_concept_id_null_pct,
  ROUND(SUM(CASE WHEN prov_type_source_concept_id = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS prov_type_source_concept_id_zero_pct

FROM provider

-- COMMAND ----------

-- MAGIC %md
-- MAGIC No nulls for provider_id or provider_name. All of the other coulmns do have NULLs or 0s in line with what was shown in the exploration.

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
-- MAGIC ## Compare rows counts

-- COMMAND ----------

SELECT
  (SELECT COUNT(*) FROM provider) AS provider_row_count,
  (SELECT COUNT(*) FROM clean_uwm_dawg.clarity_daily.clarity_ser) AS clarity_ser_row_count,
  100 * provider_row_count / clarity_ser_row_count as prop

-- COMMAND ----------

-- MAGIC %md
-- MAGIC 4% of records are being dropped from clarity_ser to the provider table by the filters, which is in line with expecations.

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
