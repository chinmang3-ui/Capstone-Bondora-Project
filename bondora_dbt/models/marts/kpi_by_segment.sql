-- Default, 12-month default and cancellation rate for every segment, in one table
{% set segments = ['rating_group', 'country', 'income_band',
                   'amount_band', 'rate_band', 'duration_band'] %}

{% for seg in segments %}
select
    '{{ seg }}'                                          as segment,
    {{ seg }}::text                                      as segment_value,
    count(*)                                             as loans,
    round(avg(is_default) * 100, 1)                      as default_rate_pct,
    round(avg(has_default_within_12_months) * 100, 1)    as default_rate_12m_pct,
    round(avg(is_cancelled) * 100, 1)                    as cancellation_rate_pct
from {{ ref('fct_loans') }}
group by {{ seg }}
{% if not loop.last %}union all{% endif %}
{% endfor %}