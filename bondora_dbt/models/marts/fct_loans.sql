-- Every loan plus segment bands for income, amount, interest rate and duration
select
    *,
    case
        when combined_income < 1500 then '1: under 1,500'
        when combined_income < 2500 then '2: 1,500–2,499'
        when combined_income < 3500 then '3: 2,500–3,499'
        else '4: 3,500+'
    end as income_band,

    case
        when issued_amount < 500  then '1: under 500'
        when issued_amount < 2000 then '2: 500–1,999'
        when issued_amount < 5000 then '3: 2,000–4,999'
        else '4: 5,000+'
    end as amount_band,

    case
        when initial_interest_rate < 0.15 then '1: under 15%'
        when initial_interest_rate < 0.20 then '2: 15–19.9%'
        when initial_interest_rate < 0.25 then '3: 20–24.9%'
        else '4: 25%+'
    end as rate_band,

    case
        when initial_loan_duration <= 12 then '1: up to 12 months'
        when initial_loan_duration <= 36 then '2: 13–36 months'
        when initial_loan_duration <= 60 then '3: 37–60 months'
        else '4: over 60 months'
    end as duration_band
from {{ ref('stg_loans') }}








