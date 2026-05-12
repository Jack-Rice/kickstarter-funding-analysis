# kickstarter-funding-analysis
SQL analysis of failed Kickstarter campaigns exploring funding performance and backer engagement patterns.
The focus is on high-engagement failed projects to understand how close they came to reaching their funding goals.

---

## Objective
To investigate whether the number of backers has any relationship with funding success (measured as funding ratio) in failed Kickstarter projects.

---

## Dataset
- Source: Kickstarter projects dataset (`ks_projects`) from Kaggle
- https://www.kaggle.com/datasets/kemical/kickstarter-projects 
- Key fields:
  - `main_category` Main category of project
  - `state` State of project (successful, canceled, etc.)
  - `backers` Number of project backers
  - `pledged` Amount pledged
  - `goal` Fundraising goal

Only failed projects are used in the analysis.

---

## Data Cleaning
The dataset was cleaned using SQL to ensure reliable analysis:

- Removed invalid values (goal ≤ 0, negative values)
- Handled missing values
- Created derived metric:
  - **fnd_ratio = pledged / goal**

This ensures consistent and meaningful comparisons across projects.

---

## Analysis Performed

### 1. Funding Performance Analysis
- Filtered for high-engagement failed projects:
  - ≥ 100 backers
  - ≥ $20,000 pledged
- Classified projects into funding categories:
  - Fully funded
  - Nearly funded
  - Not nearly funded

### 2. Backer Group Analysis
- Grouped projects by backer count:
  - 100–199
  - 200–499
  - 500–999
  - 1000+
- Compared average funding ratios across groups

---

## Key Findings
- Many failed projects still achieved relatively high funding ratios.
- Higher backer counts do not show a strong, consistent relationship with funding ratio in this filtered dataset.
- Funding performance likely depends on additional factors such as category and goal size.

---

## Tools Used
- SQL
- DBeaver
- SQLite

---

## Project Structure

01_data_cleaning.sql

02_funding_analysis.sql

README.md

---

## Future Improvements
- Add correlation analysis between backers and funding ratio
- Include category-level performance comparison
- Visualise results using Python or Tableau
