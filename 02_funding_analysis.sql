-- ANALYSIS QUESTION:
-- To what extent is engagement (measured by number of backers)
-- associated with funding performance in failed Kickstarter campaigns?
--
-- This analysis filters for high-engagement failed projects
-- (≥100 backers and ≥$20,000 pledged) to focus on campaigns
-- that attracted meaningful support but did not succeed.
--
-- Funding performance is measured using the funding ratio:
-- pledged / goal

/*===========================================================================================================================*/

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
),
failed_projects AS (
    SELECT
        main_category,
        backers,
        pledged,
        goal,
        fnd_ratio
    FROM cleaned_ks_projects
    WHERE state = 'failed'
      AND backers >= 100
      AND pledged >= 20000
),
funded_labeled_projects AS (
    SELECT
        main_category,
        backers,
        pledged,
        goal,
        fnd_ratio,
        CASE
            WHEN fnd_ratio >= 1 THEN 'Fully funded'
            WHEN fnd_ratio >= 0.75 THEN 'Nearly funded'
            ELSE 'Not nearly funded'
        END AS funding_status
    FROM failed_projects
)
SELECT *
FROM funded_labeled_projects
ORDER BY fnd_ratio DESC, main_category ASC
LIMIT  10;

-- This query categorises high-engagement failed Kickstarter projects
-- based on how close they came to reaching their funding goals.
-- It provides a ranked view of projects by funding ratio and category,
-- highlighting those that performed closest to full funding despite failure.

/*===========================================================================================================================*/

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
),
failed_projects AS (
    SELECT
        main_category,
        backers,
        pledged,
        goal,
        fnd_ratio
    FROM cleaned_ks_projects
    WHERE state = 'failed'
      AND backers >= 100
      AND pledged >= 20000
)
SELECT
    CASE
        WHEN backers BETWEEN 100 AND 199 THEN '100-199'
        WHEN backers BETWEEN 200 AND 499 THEN '200-499'
        WHEN backers BETWEEN 500 AND 999 THEN '500-999'
        ELSE '1000+'
    END AS backer_group,
    COUNT(*) AS projects,
    AVG(fnd_ratio) AS avg_fnd_ratio
FROM failed_projects
GROUP BY backer_group
ORDER BY
    MIN(backers);

-- This query groups failed Kickstarter projects by backer count
-- to compare average funding ratios across different engagement levels.
-- It helps explore whether projects with higher backer counts
-- tend to achieve higher funding completion ratios within this filtered dataset.

/*===========================================================================================================================*/

-- Overall insight:
-- The analysis suggests that within high-engagement failed projects,
-- funding ratio is not strongly differentiated by backer group size alone,
-- indicating that other factors (such as goal size or category)
-- may play a larger role in funding outcomes.