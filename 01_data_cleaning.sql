-- PURPOSE:
-- Prepare an analysis-ready version of the ks_projects dataset
-- by removing invalid values and handling missing or inconsistent data.
--
-- This script also creates derived metrics such as fnd_ratio
-- (pledged / goal) to support downstream analysis.

/*===========================================================================================================================*/
-- Inspecting structure:
PRAGMA table_info(ks_projects);

/*===========================================================================================================================*/
-- Checking for NULL key values:
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN goal IS NULL THEN 1 ELSE 0 END) AS missing_goal,
    SUM(CASE WHEN pledged IS NULL THEN 1 ELSE 0 END) AS missing_pledged,
    SUM(CASE WHEN backers IS NULL THEN 1 ELSE 0 END) AS missing_backers
FROM ks_projects;

/*===========================================================================================================================*/
-- Identifying invalid numeric values
SELECT *
FROM ks_projects
WHERE goal <= 0
   OR pledged < 0
   OR backers < 0;

/*===========================================================================================================================*/
-- While the number of invalid records appears low,
-- a cleaned dataset is created to ensure consistency in downstream analysis,
-- especially for ratio-based metrics and aggregations.

WITH cleaned_ks_projects AS (
    SELECT
        main_category,
        state,
        backers,
        pledged,
        goal,
        pledged / NULLIF(goal, 0) AS fnd_ratio
    FROM ks_projects
    WHERE goal > 0
      AND pledged >= 0
      AND backers >= 0
      AND state IS NOT NULL
)
SELECT *
FROM cleaned_ks_projects;