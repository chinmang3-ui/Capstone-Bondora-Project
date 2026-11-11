# Daily Goals

## 27-10-2026

- [x] Created the GitHub repository.
- [x] Set up Git LFS (via `.gitattributes`) to store the large Excel dataset on GitHub.
- [x] Loaded the data and started analysing each column.
- [x] Added the `README.md` file.

## 28-10-2026

- [x] Reviewed the missing-value findings with Waleed and agreed on how to handle them.
- [x] Applied the first cleaning changes in the notebook.
- [x] Updated the `README.md` (project overview, research objectives, data dictionary).
- [x] Rewrote section 3 of `changes.md` (missing values and treatment).

## 29-10-2026

- [x] Checked the missing values in every column with Waleed.
- [x] Continued the missing-value analysis for the remaining columns.
- [x] Prepared the PowerPoint presentation for Standup 1.

## 30-10-2026

- [x] Presented Standup 1 (problem, stakeholders, KPIs, data cleaning, first insight).
- [x] Decided with our coach to keep the 16,784 cancelled loans and flag them with `is_cancelled`.
- [x] Updated the slides with the cancellation rate as a new KPI.

## 02-11-2026

- [x] Created the PostgreSQL database `bondora` and loaded the clean dataset (410,865 loans) into `raw.loans` with SQLAlchemy.
- [x] Checked the data in pgAdmin with SQL; the results match pandas (default rate 13.7%).
- [x] Set up the dbt project `bondora_dbt` with `dbt init`, which created the standard folders and `dbt_project.yml` automatically.
- [x] Built the dbt models: `stg_loans` (staging), and `fct_loans`, `kpi_overall` and `kpi_by_segment` (marts).
- [x] Added dbt tests for `loan_id`, `is_default` and `rating_group`; all 5 tests pass.
- [x] Saved our SQL checks and findings in `Cleaning_and_Analyzing/data_check.sql`.

## 03-11-2026

- [x] Analysed the default rate by country, income, loan amount, interest rate and loan duration in SQL.
- [x] Connected Tableau Desktop to the PostgreSQL database.
- [x] Created our first KPI dashboard in Tableau.
- [x] Updated `README.md` and `changes.md` with the cleaning, SQL and dbt steps.