-- Headline KPIs for the whole 2023–2025 portfolio
select
    count(*)                                             as loans,
    round(avg(is_default) * 100, 1)                      as default_rate_pct,
    round(avg(is_default) filter (where is_cancelled = 0) * 100, 1)
                                                         as default_rate_excl_cancelled_pct,
    round(avg(has_default_within_12_months) * 100, 1)    as default_rate_12m_pct,
    count(has_default_within_12_months)                  as loans_with_12m_outcome,
    round(avg(is_cancelled) * 100, 1)                    as cancellation_rate_pct
from {{ ref('fct_loans') }}