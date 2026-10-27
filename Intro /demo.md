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

issued_amount, initial_interest_rate, nr_of_payments, initial_loan_duration

Describes the amount borrowed, interest rate, and repayment terms.

Loan timing and repayment progress

loan_issued_at, months_on_book, next_payment_date_local, early_repaid_at

Helps establish when a loan started and how long it has been active.

Repayment and outstanding debt

principal_balance, principal_debt, principal_paid_total, interest_paid_total, repaid_amount_total

Helps measure how much has been repaid and how much remains outstanding.

Default and risk outcomes

is_default, has_default_within_12_months, loan_status, loan_status_risk, months_in_default

These are especially important because they may tell you whether a loan became risky or defaulted.
