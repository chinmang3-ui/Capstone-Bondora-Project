-- Loans, default rate, 12-month default rate and cancellation rate per issue year
-- The 12-month default rate is the fair comparison: every loan is observed for the same 12 months
select
    issued_year,
    count(*)                                             as loans,
    sum(is_default)                                      as defaulted_loans,
    round(avg(is_default) * 100, 1)                      as default_rate_pct,
    round(avg(has_default_within_12_months) * 100, 1)    as default_rate_12m_pct,
    count(has_default_within_12_months)                  as loans_with_12m_outcome,
    round(avg(is_cancelled) * 100, 1)                    as cancellation_rate_pct
from {{ ref('fct_loans') }}
group by issued_year
order by issued_year
