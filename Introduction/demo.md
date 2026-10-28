**Project Idea**: To study credit risk: how Bondora can use information about a person applying for a loan to estimate whether that person is likely to repay it or default.

**Research question**

Which available borrower and loan characteristics are associated with loan default in Bondora's lending portfolio, and how can these findings inform credit-risk assessment and loan monitoring?

**Research objectives**

1. Describe the characteristics of loans and borrowers in the dataset.
2. Analyze associations between recorded income, loan amount, interest rate, loan duration, and default outcomes.
3. Evaluate whether selected variables can help distinguish defaulted loans from non-defaulted loans.
4. Develop evidence-based recommendations for credit-risk assessment and loan monitoring.
5. Discuss data-quality limitations, predictive leakage, and the limitations of applying the findings to traditional banks.

**Dataset Details**

The dataset has 32 columns, which can be organized into five groups.

Customer and borrower information

country, combined_income, customer_risk_rating

Helps describe the borrower's location, income, and assigned risk rating.

Loan characteristics

issued_amount, initial_interest_rate, initial_loan_duration

Describes the amount borrowed, interest rate, and repayment terms.

Loan timing and repayment progress

loan_issued_at, months_on_book, next_payment_date_local, early_repaid_at

Helps establish when a loan started and how long it has been active.

Repayment and outstanding debt

principal_balance, principal_debt, principal_paid_total, interest_paid_total, repaid_amount_total

Helps measure how much has been repaid and how much remains outstanding.

Default and risk outcomes

is_default (`default_flag`), has_default_within_12_months, loan_status, loan_status_risk, months_in_default

These are especially important because they may tell you whether a loan became risky or defaulted. 


**Definition for each column**

loan_id - **Unique identifier of the loan country Country**  **-**  The borrower’s country (Estonia, Finland, Spain, Netherland)

loan_issued_at - Time when the loan was issued The date and time the money was paid out.

early_repaid_at  **- Time when the loan was early repaid.**  The Date the whole loan was paid off before its end date.                           

issued_amount - Amount issued to the client How much was borrowed

loan_status - Status of the loan on the given date Current state: Active, Repaid, Defaulted

initial_interest_rate - Initial interest rate of the issued loan . Yearly interest rate at the start.

principal_balance - Remaining principal left to pay until the end of the loan. How much of the borrowed amount is still owed in total.

principal_debt - Unpaid principal from scheduled payments. The overdue part: principal from instalments that were due but not paid.

principal_paid_total - Total principal paid to date. How much of the borrowed amount has been paid back so far.

interest_paid_total - Total interest paid to date. How much interest the borrower has paid so far.

is_default - Flag indicating if the loan is in default 1 = in default now, 0 = not default.

next_payment_date - local Date of the next payment, if any. When the next instalment is due. Empty if repaid or defaulted.

months_in_default - Months since default occurred. NULL if not in default. How long the loan has been in default. Empty means never defaulted

months_on_book - Months the loan has been in active status. How long the loan has been running (its age).

loan_status_risk - Loan status risk category. A risk-oriented grouping of the status: Paid Up, Defaulted, Written Off

repaid_amount_total - Total repaid to date, excluding late fees Principal + interest paid back so far.

initial_loan_duration - Initial term of the loan in months . For example : Planned length: 12, 24, 36, 60 months and so on.

combined_income  **-**  Income combined from bank statement and registry data. The borrower’s income. Missing for most older loans

has_default_within_12_months -  **Whether a default happened in the first 12 months on book. NU**LL if not measurable yet. 1** = defaulted in the first year, 0 = didn’t, empty = loan is under 12 months old

customer_risk_rating  - Customer risk rating at time of issue. Rating from AA (safest) to HR (riskiest). Missing for older loans.
