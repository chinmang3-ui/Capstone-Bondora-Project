## Data Cleaning Log

This file records every change made to the raw dataset (`Modified_loan_dataset_investor.xlsx`) and the reason for it.

## 1. Time period

| Step                                   | Loans   | Reason                                                                                                 |
| -------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------ |
| Raw dataset (2009–2026)               | 843,755 | There is no records for the combined_income and risk_rating_system from 2009- 2022.                    |
| Keep loans issued **2023–2025** | 410,867 | Income and risk rating are fully recorded from 2023. Loans from 2026 are too young to show an outcome. |

## 2. Removed rows

| Rows | Reason                                                                                       |
| ---- | -------------------------------------------------------------------------------------------- |
| 2    | `combined_income` was missing (isolated gaps). Removing them has no effect on the results. |

**Final dataset: 410,865 loans.** No other rows were removed.

## 3. Data type changes

| Column(s)                                          | Before               | After                                   | Reason                                                                                   |
| -------------------------------------------------- | -------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------- |
| `country`, `loan_status`, `loan_status_risk` | string               | category                                | Labels with few unique values. Saves memory and speeds up grouping.                      |
| `customer_risk_rating`                           | string               | ordered category (AA < A < … < G < HR) | Ratings follow a risk scale, so the order is kept for sorting and charts.                |
| `is_default`, `has_default_within_12_months`   | float64              | Int8 (nullable integer)                 | These are 0/1 flags. They were stored as float only because they contain missing values. |
| `early_repaid_at`, `next_payment_date_local`   | mixed text / numbers | datetime                                | Some dates were stored as Excel date numbers (e.g. 46339). Converted to real dates.      |

## 4. Removed columns

| Column             | Reason                                                                                                                         |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| `nr_of_payments` | Only filled on the day a payment is due, so it reflects the extraction date rather than the loan. Not useful for the analysis. |

## 5. New columns

| Column                     | Meaning                                         | Why                                                                                                                                      |
| -------------------------- | ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `months_in_default_flag` | 1 = loan has defaulted, 0 = never defaulted     | `months_in_default` is empty for non-defaulted loans; 0 already means "defaulted less than a month ago", so we did not fill it with 0. |
| `rating_group`           | Risk rating, with "Unrated" for missing ratings | Lets us compare unrated loans with the rated grades.                                                                                     |
| `is_cancelled`           | 1 = cancelled loan, 0 = not cancelled           | Cancelled loans are kept (coach decision) and can be included or excluded per analysis.                                                  |

## 6. Missing values (2023–2025, 410,865 loans)

| Column                           | Missing                   | Explanation                                                   | Treatment                                                                                  |
| -------------------------------- | ------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `months_in_default`            | 354,501 (86.3%)           | Loan never defaulted (missing by design).                     | Kept; created `months_in_default_flag`.                                                  |
| `early_repaid_at`              | 278,773 (67.9%)           | Loan was not repaid early (missing by design).                | Kept as missing.                                                                           |
| `next_payment_date_local`      | 223,712 (54.4%)           | No payment due: loan repaid or defaulted (missing by design). | Kept as missing; not used to explain default.                                              |
| `customer_risk_rating`         | 56,466 (13.7%)            | Loans issued without a rating, mostly Finland 2023.           | Kept; grouped as "Unrated" in `rating_group`.                                            |
| `has_default_within_12_months` | 25,466 (6.2%), was 37,141 | Active loans younger than 12 months; outcome not yet known.   | Filled where known (defaulted → 1, repaid → 0); the rest excluded from the 12-month KPI. |
| `months_on_book`               | 2,487 (0.6%)              | Cancelled loans that never ran.                               | Kept; cancelled loans flagged with `is_cancelled`.                                       |
| `combined_income`              | 2                         | Isolated gaps.                                                | 2 rows removed.                                                                            |

All other 14 columns have no missing values.

## 7. Cancelled loans

16,784 loans (4.1%) are cancelled: the borrower returned the money shortly after payout. After discussing with our coach, we **keep** them and flag them with `is_cancelled`.

- Default rate with cancelled loans: **13.7%** (main KPI)
- Default rate without cancelled loans: **14.3%**

## 8. Decisions and limitations

- **Written-off loans (14,185):** kept in the dataset as they are, the same way as the cancelled loans (agreed with our coach). They follow Bondora's definition in `is_default`, so they count as *not defaulted*, even though investors lost part of their money on them.
- **HR rating:** only 19 loans, too few to draw conclusions, so it is left out of the rating comparison.

## 9. Loading into PostgreSQL and dbt

| Step      | What we did                                                                                                                                                              |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Save      | Clean data saved as `data/loans_clean.parquet` (410,865 rows, 24 columns).                                                                                             |
| Load      | Loaded into PostgreSQL, database `bondora`, table `raw.loans`. The password is entered with `getpass`, so it is never saved in the notebook.                       |
| Transform | dbt builds `stg_loans` → `fct_loans` (with income, amount, interest-rate and duration bands) → `kpi_overall` and `kpi_by_segment` in the `analytics` schema. |
| Test      | 5 dbt tests pass: `loan_id` is unique and not null, `is_default` is only 0 or 1, `rating_group` is never empty and only contains valid grades.                     |
| Check     | SQL results match pandas: 13.7% default rate, 9.1% 12-month rate, AA 5.5% → G 26.5%.                                                                                    |


bondora                      ← the database
├── public      ← default folder, created automatically by PostgreSQL (empty)
├── raw         ← created by us (notebook): the clean data as loaded
└── analytics   ← created by dbt: the KPI tables for Tableau
