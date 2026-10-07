---
name: add-task
description: Step-by-step guide for creating the Databricks bundle task to populate a new OMOP CDM table in the omop-cdm-v5.4 project. Read this skill when the user asks to add a new table to the OMOP CDM pipeline once they have already created all the related transformation code, documentation, and DQX checks.
---

# Populate New OMOP Table

This skill documents the complete process for adding a new task to the job running the OMOP table refresh for the `omop-cdm-v5.4` project.

## Add Task to Job YAML

**File:** `resources/jobs/omop_table_refresh.job.yml`

Add a new task entry to the `tasks` list in the appropriate position based on dependencies.

### Template Task Entry

```yaml
        - task_key: <table_name>_table_refresh
          depends_on:
            - task_key: <upstream_dependency_task>
          sql_task:
            file:
              path: ../../models/<table_name>/populate_<table_name>_table.sql
            parameters:
              clarity_catalog: ${var.clarity_catalog}
              clarity_daily_schema: ${var.clarity_daily_schema}
              clarity_weekly_schema: ${var.clarity_weekly_schema}
              omop_catalog: ${var.omop_catalog}
              omop_schema: ${var.omop_schema}
              omop_intermediate_schema: ${var.omop_intermediate_schema}
            warehouse_id: ${var.warehouse_id}
```

### Dependency Rules

| If the table... | Then `depends_on`... |
| --- | --- |
| Needs only person data | `person_table_refresh` |
| Needs visit_occurrence | `visit_occurrence_table_refresh` |
| Is a terminal/summary table | All upstream domain table tasks |
| Needs no upstream OMOP tables | `person_preprocessing` |

### Available Parameters

Only include parameters actually used by the SQL file:

| Parameter | Variable | When to Include |
| --- | --- | --- |
| `clarity_catalog` | `${var.clarity_catalog}` | Always (source data) |
| `clarity_daily_schema` | `${var.clarity_daily_schema}` | When using daily-refresh Clarity tables |
| `clarity_weekly_schema` | `${var.clarity_weekly_schema}` | When using weekly-refresh Clarity tables |
| `omop_catalog` | `${var.omop_catalog}` | Always (target) |
| `omop_schema` | `${var.omop_schema}` | Always (target table location) |
| `omop_intermediate_schema` | `${var.omop_intermediate_schema}` | When using intermediate tables |
| `takepartnw_catalog` | `${var.takepartnw_catalog}` | When using TakePart NW data |
| `takepartnw_schema` | `${var.takepartnw_schema}` | When using TakePart NW data |

### Task Positioning

The current job DAG order is:
1. `person_preprocessing` (no dependencies)
2. `location_table_refresh` → depends on person_preprocessing
3. `person_table_refresh` → depends on location
4. `observation_research_study_refresh` → depends on person
5. `death_table_refresh` → depends on person
6. `visit_occurrence_table_refresh` → depends on death
7. Domain tables (condition_occurrence, procedure_occurrence, measurement, drug_exposure, observation_period) → depend on visit_occurrence
8. `observation_combined` → depends on observation_research_study
9. `cdm_source_table_refresh` → depends on all domain tables
10. `dqx_validation` → depends on cdm_source

New domain tables that reference visits should depend on `visit_occurrence_table_refresh`. Add the new task BEFORE `cdm_source_table_refresh` and add it as a dependency of `cdm_source_table_refresh`.

---


## Checklist

When creating a new OMOP table, complete these steps in order:

- [ ] Add task to `resources/jobs/omop_table_refresh.job.yml`
- [ ] Add new task as dependency of `cdm_source_table_refresh`
- [ ] Verify all parameter references match variables defined in `resources/variables/`
