-- Default rate for combinations of two segments (rating x country, rating x duration)
-- Shows WHY some groups are risky: is it the rating, or the country / loan length?
{% set pairs = [('rating_group', 'country'),
                ('rating_group', 'duration_band')] %}

{% for seg_1, seg_2 in pairs %}
select
    '{{ seg_1 }} x {{ seg_2 }}'                          as combination,
    {{ seg_1 }}::text                                    as value_1,
    {{ seg_2 }}::text                                    as value_2,
    count(*)                                             as loans,
    round(avg(is_default) * 100, 1)                      as default_rate_pct,
    round(avg(has_default_within_12_months) * 100, 1)    as default_rate_12m_pct,
    round((avg(initial_interest_rate) * 100)::numeric, 1) as avg_interest_rate_pct,
    count(*) < 100                                       as is_small_group
from {{ ref('fct_loans') }}
group by {{ seg_1 }}, {{ seg_2 }}
{% if not loop.last %}union all{% endif %}
{% endfor %}