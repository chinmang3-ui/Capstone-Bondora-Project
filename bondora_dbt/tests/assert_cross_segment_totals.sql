-- Custom test: checks that no loans are lost
-- Every combination must add up to all loans in fct_loans (410,865).
-- The test PASSES when this query returns 0 rows.
select
    combination,
    sum(loans) as total_loans
from {{ ref('kpi_cross_segment') }}
group by combination
having sum(loans) <> (select count(*) from {{ ref('fct_loans') }})



