-- One row per loan, only the columns we analyse, with clear names
with source as (
    select * from {{ source('raw', 'loans') }}
)

select
    loan_id,
    country,
    loan_issued_at,
    extract(year from loan_issued_at)::int as issued_year,
    issued_amount,
    initial_interest_rate,
    initial_loan_duration,
    combined_income,
    customer_risk_rating,
    rating_group,
    loan_status,
    loan_status_risk,
    is_default,
    has_default_within_12_months,
    is_cancelled,
    months_on_book,
    months_in_default
from source