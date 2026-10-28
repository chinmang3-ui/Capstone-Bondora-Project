## Data Cleaning Log

This file records every change made to the raw dataset (`loan_dataset_investor.xlsx`) and the reason for it.

## 1. Data type changes

| Column(s)                                          | Before  | After                                                  | Reason                                                                                   |
| -------------------------------------------------- | ------- | ------------------------------------------------------ | ---------------------------------------------------------------------------------------- |
| `country`, `loan_status`, `loan_status_risk` | string  | category                                               | Labels with few unique values. Saves memory and speeds up grouping.                      |
| `customer_risk_rating`                           | string  | ordered category (AA < A < B < C < D < E < F < G < HR) | Ratings follow a risk scale, so the order is kept for sorting and charts.                |
| `is_default`, `has_default_within_12_months`   | float64 | Int8 (nullable integer)                                | These are 0/1 flags. They were stored as float only because they contain missing values. |

## 2. Removed columns

| Column             | Reason                                                                                                                         |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| `nr_of_payments` | Only filled on the day a payment is due, so it reflects the extraction date rather than the loan. Not useful for the analysis. |

## 3. Missing values

| Column                           | Missing           | Explanation                                                                                                                    | Treatment                                                                      |
| -------------------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| `is_default`                   | 7,713 rows (≈1%) | Linked to loans without repayment data.                                                                                        | Under review (see section 4).                                                  |
| `customer_risk_rating`         | ≈43%             | Rating not available for older loans.                                                                                          | Kept as missing. Rating analysis uses rated loans only.                        |
| `combined_income`              | ≈35%             | Income not recorded for many older loans.                                                                                      | Kept as missing. Not filled with 0.                                            |
| `has_default_within_12_months` | ≈23%             | Mostly recent loans that have not yet been on the books for 12 months (per the data dictionary: "NULL if not measurable yet"). | Kept as missing. 12-month default rate is calculated on measurable loans only. |
| `months_in_default`            | ≈86%             | Empty when the loan has never defaulted (per the data dictionary).                                                             | Missing by design.                                                             |
| `early_repaid_at`              | ≈71%             | Empty when the loan was not repaid early.                                                                                      | Missing by design.                                                             |
| `next_payment_date_local`      | ≈58%             | Empty when no further payment is scheduled (repaid or defaulted).                                                              | Missing by design.                                                             |

## 4. Open items

- **Cancelled loans:** the 7,713 rows missing `is_default` also have no repayment data (`principal_balance`, `principal_debt`, `repaid_amount_total`) and are mostly `Returned` / `Cancelled`. Proposed action: remove them, as they have no default outcome. To confirm with Waleed.
- **`default_flag`:** currently fills missing `is_default` with 0. To be rebuilt from `is_default` once the cancelled loans are removed.
