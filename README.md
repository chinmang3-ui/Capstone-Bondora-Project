## Project Overview

**Bondora** is a European peer-to-peer lending platform. Borrowers apply for loans online, and the loans are **funded by investors** rather than by a bank. In 2023–2025, Bondora lent in **Finland, Estonia, the Netherlands, Latvia, Denmark and Spain**.

This project studies **credit risk** in Bondora's loan portfolio. The full dataset contains 843,755 loans (2009–2026); we analyse the **410,865 loans issued between 2023 and 2025**. We identify which borrower characteristics and loan terms are linked to default, and translate these findings into practical recommendations for lenders and investors.

Link for our Dataset : [goandgrow.eu/en/public-statistics](https://goandgrow.eu/en/public-statistics/)

## Research Question

Which borrower and loan characteristics are associated with loan default in Bondora's lending portfolio, and how can these findings inform credit-risk assessment and loan monitoring?

## Research Objectives

The aim is to identify patterns in default: **which borrowers** default more often and **which types of loans** are most likely to default.

1. Describe the characteristics of the loans and borrowers in the dataset.
2. Analyse the relationship between income, loan amount, interest rate, loan duration and default.
3. Evaluate whether selected variables can help distinguish defaulted loans from non-defaulted loans.
4. Develop evidence-based recommendations for credit-risk assessment and loan monitoring.
5. Discuss the limitations of the analysis, including data quality, predictive leakage, and how far the findings apply to traditional banks.

## Dataset Structure

**Dataset Overview**

The raw dataset contains 843,755 loans and 22 columns. After cleaning, the analysis dataset contains 410,865 loans (2023–2025) and 24 columns.

### 1. Borrower information

`country`, `combined_income`, `customer_risk_rating`
Describes the borrower's location, income and assigned risk rating.

### 2. Loan characteristics

`issued_amount`, `initial_interest_rate`, `initial_loan_duration`
Describes the amount borrowed, the interest rate and the repayment term.

### 3. Loan timing and repayment progress

`loan_issued_at`, `months_on_book`, `next_payment_date_local`, `early_repaid_at`
Shows when a loan started and how long it has been running.

### 4. Repayment and outstanding debt

`principal_balance`, `principal_debt`, `principal_paid_total`, `interest_paid_total`, `repaid_amount_total`
Measures how much has been repaid and how much is still owed.

### 5. Default and risk outcomes

`is_default`, `has_default_within_12_months`, `loan_status`, `loan_status_risk`, `months_in_default`

## Data Dictionary

### Original columns

| Column | Definition |
|---|---|
| `loan_id` | Unique identifier of the loan. |
| `country` | The borrower's country: Finland, Estonia, Netherlands, Spain, Latvia, Denmark, Slovakia, Lithuania. The 2023–2025 analysis contains six of them (no loans from Slovakia; the only Lithuanian loan was removed because its income was missing). |
| `loan_issued_at` | Date and time the loan was issued (the money was paid out). |
| `early_repaid_at` | Date the whole loan was paid off before its planned end date. Empty if the loan was not repaid early. |
| `issued_amount` | Amount lent to the borrower. |
| `loan_status` | Status of the loan on the date the data was extracted: Active, Repaid or Defaulted. |
| `initial_interest_rate` | Yearly interest rate set when the loan was issued (0.17 = 17%). |
| `nr_of_payments` | Number of payments due on the extraction date. *Dropped in the analysis* (depends on the extraction date, not on the loan). |
| `principal_balance` | Principal still left to pay until the end of the loan. |
| `principal_debt` | Overdue principal: the part of the borrowed amount from instalments that were due but not paid. |
| `principal_paid_total` | Total principal paid back to date. |
| `interest_paid_total` | Total interest paid to date. |
| `is_default` | Whether the loan is in default: 1 = in default, 0 = not in default. Main outcome of the analysis. |
| `next_payment_date_local` | Date the next instalment is due, in the borrower's local time. Empty if the loan is repaid or defaulted. |
| `months_in_default` | Number of months since the loan went into default. Empty means the loan has never defaulted. |
| `months_on_book` | Number of months the loan has been active (its age). Empty for cancelled loans that never ran. |
| `loan_status_risk` | Risk-oriented grouping of the loan status: Active, Paid Up, Defaulted, Written Off, Cancelled. |
| `repaid_amount_total` | Total repaid to date (principal + interest), excluding late fees. |
| `initial_loan_duration` | Planned length of the loan in months, e.g. 12, 24, 36, 60. |
| `combined_income` | Borrower's monthly income, combined from bank statement and registry data. Missing for most loans before 2022. |
| `has_default_within_12_months` | Whether the loan defaulted within its first 12 months: 1 = yes, 0 = no. Empty if the loan is not yet 12 months old. |
| `customer_risk_rating` | Risk rating given to the borrower when the loan was issued, from AA (safest) to HR (riskiest). Missing for older loans and for some loans issued without a rating. |

### Columns created in the analysis

| Column | Definition |
|---|---|
| `months_in_default_flag` | 1 = the loan has defaulted, 0 = it has never defaulted. |
| `rating_group` | `customer_risk_rating` with "Unrated" for loans without a rating. |
| `is_cancelled` | 1 = cancelled loan, 0 = not cancelled. Cancelled loans are kept in the data. |

## Key Performance Indicators (KPIs)

The analysis is based on **410,865 loans issued between 2023 and 2025**. Cancelled loans are kept and flagged with `is_cancelled`.

### KPI definitions

| KPI | Definition | Why it matters |
|---|---|---|
| **Default rate** | Share of loans in default (`is_default` = 1) | Main outcome of the analysis |
| **12-month default rate** | Share of loans that defaulted within their first 12 months, for loans with a known 12-month outcome | Early warning signal; fair comparison, since every loan is observed for the same time |
| **Cancellation rate** | Share of loans cancelled shortly after payout (`is_cancelled` = 1) | Shows which groups return the money early |
| **Default rate by segment** | Default rate by risk rating, country, income, loan amount, interest rate and loan duration | Shows which borrower and loan groups drive risk |
| **Data completeness** | Share of missing values per column, and why | Shows how far the results can be trusted |

### Results so far

| KPI | Result | Status |
|---|---|---|
| Default rate | **13.7%** (56,364 of 410,865 loans); 14.3% without cancelled loans | ✅ Completed |
| 12-month default rate | **9.1%** (of 385,399 loans with a known outcome) | ✅ Completed |
| Cancellation rate | **4.1%** (16,784 loans) | ✅ Completed |
| Default rate by risk rating | Rises steadily from **AA (5.5%)** to **G (26.5%)**; unrated loans: **16.7%** | ✅ Completed |
| Default rate by country | From **Netherlands (8.6%)** to **Spain (51.5%)**; Finland (66% of loans): 13.1% | ✅ Completed |
| Default rate by income, amount, interest rate and duration | Calculated in SQL (`analytics.kpi_by_segment`); interpretation in progress | ⏳ In progress |
| Data completeness | All 21 columns checked; every missing value explained | ✅ Completed |

### Notes

- The **12-month default rate** excludes 25,466 active loans younger than 12 months, because their outcome is not yet known.
- The **HR** rating group contains only 19 loans and is too small to draw conclusions.
- **Unrated loans** default more often than the average, which makes the missing rating itself a risk signal.
- **Spain, Latvia and Denmark** have high default rates but are small groups (1,578 to 8,363 loans).
- **Written-off loans** (14,185) are kept in the dataset and counted as not defaulted, following Bondora's definition.

## Missing-value summary (2023–2025, 410,865 loans)

All 21 original columns were checked. **14 have no missing values.** The other 7 had missing values, and each one has been explained and handled.

### Columns with missing values

| Column | Missing | Missing % | Reason | Treatment |
|---|---|---|---|---|
| `months_in_default` | 354,501 | 86.3% | Loan never defaulted (missing by design) | Kept as missing; created `months_in_default_flag` |
| `early_repaid_at` | 278,773 | 67.9% | Loan was not paid off early (missing by design) | Kept as missing; Excel numbers converted to dates |
| `next_payment_date_local` | 223,712 | 54.4% | Repaid or defaulted loans have no next payment (missing by design) | Kept as missing; Excel numbers converted to dates; not used to explain default |
| `customer_risk_rating` | 56,466 | 13.7% | Loans issued without a rating | Kept as missing; grouped as "Unrated" in `rating_group` |
| `has_default_within_12_months` | 25,466 (was 37,141) | 6.2% | Active loans younger than 12 months; outcome not yet known | Filled where known (defaulted → 1, repaid → 0); the rest left out of the 12-month KPI |
| `months_on_book` | 2,487 | 0.6% | Cancelled loans that never ran | Kept as missing; cancelled loans flagged with `is_cancelled` |
| `combined_income` | 0 (was 2) | 0.0% | 2 isolated gaps | 2 rows removed |

### Columns without missing values

`loan_id`, `country`, `loan_issued_at`, `issued_amount`, `loan_status`, `initial_interest_rate`, `principal_balance`, `principal_debt`, `principal_paid_total`, `interest_paid_total`, `is_default`, `loan_status_risk`, `repaid_amount_total`, `initial_loan_duration`

### Dropped column

| Column | Reason |
|---|---|
| `nr_of_payments` | Depends on the data extraction date, not on the loan; no information about default risk |

### New columns created

| Column | Meaning | Missing |
|---|---|---|
| `months_in_default_flag` | 1 = the loan has defaulted, 0 = it has never defaulted | 0 |
| `rating_group` | `customer_risk_rating`, with "Unrated" for loans without a rating | 0 |
| `is_cancelled` | 1 = cancelled loan, 0 = not cancelled (cancelled loans are kept in the data) | 0 |

### Summary

- Most gaps are **missing by design**: the field does not apply to that loan (no early repayment, no next payment, never defaulted, outcome not yet known).
- No values were invented. We added flags, created an "Unrated" group, and removed only **2 rows**.
- The **16,784 cancelled loans** and **14,185 written-off loans** are kept in the data, as agreed with our coach.

## Data Pipeline

The project follows ten steps, from the raw Excel file to the final presentation. Code and documentation are versioned with **Git and GitHub** throughout.

| Step | Stage | What we do | Tools | Status |
|---|---|---|---|---|
| 1 | **Source** | Review the raw loan file and the data dictionary | Excel | ✅ Done |
| 2 | **Load** | Read the Excel file and save it as Parquet for fast reloading | Python, pandas | ✅ Done |
| 3 | **Filter** | Keep loans issued 2023–2025 (843,755 → 410,867 loans) | pandas | ✅ Done |
| 4 | **Data types** | Convert columns to categories and 0/1 flags; order the risk rating from AA (best) to HR (riskiest); convert Excel date numbers to real dates | pandas | ✅ Done |
| 5 | **Clean** | Drop `nr_of_payments`; remove 2 rows with missing income; explain every missing value; create `months_in_default_flag`, `rating_group` and `is_cancelled`; fill the 12-month flag where the outcome is known | pandas | ✅ Done |
| 6 | **KPIs** | Default rate, 12-month default rate, cancellation rate and default rate by segment (rating and country done; income, amount, interest rate and duration in progress) | pandas, SQL | 🔶 In progress |
| 7 | **Store and transform** | Load the clean data into PostgreSQL (`raw.loans`) and build tested KPI tables with dbt (`analytics` schema) | PostgreSQL, pgAdmin, dbt | ✅ Done |
| 8 | **Visualise** | Charts of default rates by segment and an interactive dashboard | matplotlib, seaborn, Tableau | ⬜ Planned |
| 9 | **Model** | Simple prediction model using only information known when the loan is issued (to avoid leakage) | scikit-learn | ⬜ Planned |
| 10 | **Present** | Findings and recommendations for credit-risk assessment and loan monitoring | PowerPoint | ⬜ Planned |

### Dataset size at each step

| Step | Loans |
|---|---|
| Raw dataset (2009–2026) | 843,755 |
| After year filter (2023–2025) | 410,867 |
| After removing 2 rows with missing income | **410,865** |
| With a known 12-month outcome | 385,399 |

### Current results

- Default rate: **13.7%** (56,364 of 410,865 loans); 14.3% without cancelled loans
- 12-month default rate: **9.1%** (of 385,399 loans)
- Cancellation rate: **4.1%** (16,784 loans)
- Default rate rises steadily with the risk rating, from **5.5% (AA)** to **26.5% (G)**
- Default rate by country ranges from **8.6% (Netherlands)** to **51.5% (Spain)**

## SQL and dbt

The clean data is stored in **PostgreSQL** and transformed with **dbt**, so every KPI can be rebuilt with one command.

### Flow

```
loans_clean.parquet → raw.loans → stg_loans → fct_loans → kpi_overall, kpi_by_segment
     (pandas)        (PostgreSQL)  (dbt view)  (dbt table)        (dbt tables)
```

### dbt models (`bondora_dbt/models`)

| Model | Type | What it does |
|---|---|---|
| `staging/stg_loans` | view | Selects the columns we analyse from `raw.loans` and adds `issued_year` |
| `marts/fct_loans` | table | One row per loan, plus bands for income, loan amount, interest rate and duration |
| `marts/kpi_overall` | table | Headline KPIs: default rate, 12-month default rate, cancellation rate |
| `marts/kpi_by_segment` | table | The same KPIs for every rating, country, income, amount, interest-rate and duration group |

### Tests

`dbt build` runs 5 tests: `loan_id` is unique and never empty, `is_default` is only 0 or 1, and `rating_group` is never empty and only contains valid grades. All tests pass.

### How to run it

1. Create a PostgreSQL database called `bondora`.
2. Run `analysis.ipynb` to the end. The last cell loads the clean data into `raw.loans`.
3. Install dbt: `pip install dbt-postgres`
4. In `bondora_dbt`, run `dbt init` to set up your own connection. It is saved in `~/.dbt/profiles.yml`, outside the repository, so passwords are never on GitHub.
5. Run `dbt build`.
6. The results are in the `analytics` schema, e.g. `SELECT * FROM analytics.kpi_overall;`

## Repository Structure

```
Capstone-Bondora-Project/
├── Cleaning_and_Analyzing/
│   ├── analysis.ipynb        # cleaning, missing values, KPIs, load into PostgreSQL
│   ├── changes.md            # log of every cleaning step and decision
│   └── data_check.sql        # SQL checks and findings in pgAdmin
├── bondora_dbt/
│   └── models/
│       ├── staging/          # sources.yml, stg_loans.sql
│       └── marts/            # fct_loans, kpi_overall, kpi_by_segment, tests
├── data/                     # raw Excel file and Parquet files
├── Goals/
│   └── daily_goals.md        # daily progress
├── Bondora Credit Risk – Standup.pptx
└── README.md
```
