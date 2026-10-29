## Project Overview

**Bondora** is a European peer-to-peer lending platform. Borrowers in **Estonia, Finland, Spain, Netherlands, Denamrk, Latvia, Slovakia, Lithuania**  apply for loans online, and the loans are **funded by investors** rather than by a bank.

This project studies **credit risk** in Bondora's loan portfolio. Using data on about 7,90,000 loans, we identify which borrower characteristics and loan terms are linked to default, and translate these findings into practical recommendations for lenders and investors.

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

The dataset contains 789,144 loans and 22 columns. The columns fall into five groups.

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

`is_default` (`default_flag`), `has_default_within_12_months`, `loan_status`, `loan_status_risk`, `months_in_default`
Shows whether a loan became risky or defaulted. These are the outcomes the analysis tries to explain.

## Data Dictionary

| Column                           | Definition                                                                                                              |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `loan_id`                      | Unique identifier of the loan.                                                                                          |
| `country`                      | The borrower's country (Estonia, Finland, Spain, Netherlands).                                                          |
| `loan_issued_at`               | Date and time the loan was issued (the money was paid out).                                                             |
| `early_repaid_at`              | Date the whole loan was paid off before its planned end date. Empty if the loan was not repaid early.                   |
| `issued_amount`                | Amount lent to the borrower.                                                                                            |
| `loan_status`                  | Status of the loan on the date the data was extracted, e.g. Active, Repaid, Defaulted.                                  |
| `initial_interest_rate`        | Yearly interest rate set when the loan was issued (0.17 = 17%).                                                         |
| `principal_balance`            | Principal still left to pay until the end of the loan.                                                                  |
| `principal_debt`               | Overdue principal: the part of the borrowed amount from instalments that were due but not paid.                         |
| `principal_paid_total`         | Total principal paid back to date.                                                                                      |
| `interest_paid_total`          | Total interest paid to date.                                                                                            |
| `is_default`                   | Whether the loan is in default: 1 = in default, 0 = not in default.                                                     |
| `next_payment_date_local`      | Date the next instalment is due, in the borrower's local time. Empty if the loan is repaid or defaulted.                |
| `months_in_default`            | Number of months since the loan went into default. Empty means the loan has never defaulted.                            |
| `months_on_book`               | Number of months the loan has been active (its age).                                                                    |
| `loan_status_risk`             | Risk-oriented grouping of the loan status, e.g. Paid Up, Defaulted, Written Off, Cancelled.                             |
| `repaid_amount_total`          | Total repaid to date (principal + interest), excluding late fees.                                                       |
| `initial_loan_duration`        | Planned length of the loan in months, e.g. 12, 24, 36, 60.                                                              |
| `combined_income`              | Borrower's income, combined from bank statement and registry data. Missing for many older loans.                        |
| `has_default_within_12_months` | Whether the loan defaulted within its first 12 months: 1 = yes, 0 = no. Empty if the loan is not yet 12 months old.     |
| `customer_risk_rating`         | Risk rating given to the borrower when the loan was issued, from AA (safest) to HR (riskiest). Missing for older loans. |
| `default_flag`                 | *Created in the analysis.* Copy of `is_default` as a whole number (0/1), used for calculating default rates.        |
