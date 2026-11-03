-- Look in the raw schema first
SET search_path TO raw;

SELECT *
FROM loans
LIMIT 10;

-- How many loans?
SELECT COUNT(*) FROM raw.loans;  

__So the output shows there are totally 410865 rows.

-- Overall default rate
SELECT ROUND(AVG(is_default) * 100, 1) AS default_rate_pct
FROM raw.loans;   

--so the output shows the dafault rate is 13.7

-- Default rate per risk rating
SELECT rating_group,
       COUNT(*) AS loans,
       ROUND(AVG(is_default) * 100, 1) AS default_rate_pct
FROM raw.loans
GROUP BY rating_group
ORDER BY default_rate_pct;

--The output shows,The default rate rises steadily as the risk rating gets worse: 
--from **5.5% for AA** (the safest borrowers) to **26.5% for G**.

SELECT * FROM analytics.kpi_overall;
SELECT * FROM analytics.kpi_by_segment WHERE segment = 'rating_group';

--The output shows

SELECT * FROM analytics.kpi_by_segment WHERE segment = 'country'       ORDER BY segment_value;

--The output shows the Netherlands has the lowest default rate (8.6%), and Spain the highest (51.5%). 
--Finland makes up 66% of all loans and sits near the average (13.1%). Spain, Latvia and Denmark 
--default the most, but they are small groups.

SELECT * FROM analytics.kpi_by_segment WHERE segment = 'income_band'   ORDER BY segment_value;
--The default rate falls as income rises: from **19.6%** for borrowers earning under 1,500 to **10.1%** for those earning 3,500 or more. 
--Low-income borrowers default almost **twice as often**.
--The 12-month default rate shows the same pattern (13.9% → 6.4%), so the result holds when every loan is observed over the same first year.
--The biggest difference is between the lowest income group and the next one (19.6% vs 14.0%). Above 2,500, higher income lowers the risk only a little.
--The cancellation rate is about 4% in every group, so income affects default but not cancellation.

SELECT * FROM analytics.kpi_by_segment WHERE segment = 'amount_band'   ORDER BY segment_value;

--The default rate does not rise steadily with the loan amount. 
--It increases from **10.3%** for loans under 500 to **17.4%** for loans of 2,000–4,999
--then falls to **13.5%** for loans of 5,000 or more
--Loans of **2,000–4,999** are the riskiest group: about one in six defaults.
--the largest loans are less risky than medium-large loans, possibly because they are given to borrowers with higher income or better ratings (to be checked).
--The 12-month default rate shows the same pattern, so the result is not caused by loan age.
--Small loans are cancelled most often (6.6%), probably because a small amount is easy to return shortly after payout.

SELECT * FROM analytics.kpi_by_segment WHERE segment = 'rate_band'     ORDER BY segment_value;

--The default rate rises with the interest rate: from **9.3%** for loans under 15% to **24.7%** for loans at 25% or more, about **2.7 times higher**.
--The biggest increase is in the highest group: one in four loans with an interest rate of 25% or more defaults.
--Most loans (69%) have an interest rate between 15% and 19.9%.
--The 12-month default rate shows the same overall pattern (5.5% → 17.7%).
--The interest rate does not cause default: Bondora sets higher rates for borrowers it already considers risky. 
--A high interest rate is therefore a **signal** of risk, like a poor rating.
--The cancellation rate is similar in every group (3.5–4.3%)


SELECT * FROM analytics.kpi_by_segment WHERE segment = 'duration_band' ORDER BY segment_value;

--Short loans are the safest: loans of up to 12 months default at **5.3%**.
--Loans of **37–60 months** are the riskiest (**18.1%**) and also the largest group (49% of all loans).
--Loans of over 60 months show a lower default rate (11.2%), but most of them are still running and have not had time to default.
--Their final default rate is likely to be higher. 
--The 12-month default rate gives a fairer comparison and still shows 37–60 months as the riskiest group (10.6%).
--For loans of up to 12 months, the default rate and the 12-month default rate are the same, because the whole loan falls within its first year.
--Short loans are cancelled most often (9.7%)






