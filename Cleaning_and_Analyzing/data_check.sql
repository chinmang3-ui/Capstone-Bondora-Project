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
---------------------------------------------------------
---12Months_default_rate

SELECT ROUND(AVG(has_default_within_12_months) * 100, 1) AS default_rate_pct
FROM raw.loans;  

--So the output shows the has defualt rate within 12 months is 9.1%
--

-- Default rate per risk rating
SELECT rating_group,
       COUNT(*) AS loans,
       ROUND(AVG(is_default) * 100, 1) AS default_rate_pct
FROM raw.loans
GROUP BY rating_group
ORDER BY default_rate_pct;

--The output shows,The default rate rises steadily as the risk rating gets worse: 
--from **5.5% for AA** (the safest borrowers) to **26.5% for G**.
--------------------------------

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
--then falls to **13.5%** for loans of 5,000 or more.
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
--The cancellation rate is similar in every group (3.5–4.3%).


SELECT * FROM analytics.kpi_by_segment WHERE segment = 'duration_band' ORDER BY segment_value;

--Short loans are the safest: loans of up to 12 months default at **5.3%**.
--Loans of **37–60 months** are the riskiest (**18.1%**) and also the largest group (49% of all loans).
--Loans of over 60 months show a lower default rate (11.2%), but most of them are still running and have not had time to default.
--Their final default rate is likely to be higher. 
--The 12-month default rate gives a fairer comparison and still shows 37–60 months as the riskiest group (10.6%).
--For loans of up to 12 months, the default rate and the 12-month default rate are the same, because the whole loan falls within its first year.
--Short loans are cancelled most often (9.7%).

-- =====================================================
-- A. DATA QUALITY CHECKS
-- =====================================================

-- Duplicate loan IDs?
SELECT COUNT(*) - COUNT(DISTINCT loan_id) AS duplicate_ids
FROM raw.loans;
-- The output shows 0 duplicates: every loan appears once.

-- Are the values in a sensible range?
SELECT MIN(issued_amount)          AS min_amount,
       MAX(issued_amount)          AS max_amount,
       MIN(initial_interest_rate)  AS min_rate,
       MAX(initial_interest_rate)  AS max_rate,
       MIN(initial_loan_duration)  AS min_duration,
       MAX(initial_loan_duration)  AS max_duration,
       MIN(combined_income)        AS min_income,
       MAX(combined_income)        AS max_income
FROM raw.loans;
-- No negative amounts. Interest rates are 4.5%–33.7%, durations 3–120 months.
-- Income ranges from 0 to 177,872 EUR per month, so there are some extreme values.
------------------------------------------------------------------------------------
-- How many loans have an income of 0?
SELECT COUNT(*) AS zero_income_loans,
       ROUND(AVG(is_default) * 100, 1) AS default_rate_pct
FROM raw.loans
WHERE combined_income = 0;
-- 190 loans have an income of 0 (0.05%), with a default rate of 19.5%.
-- They are too few to change the results, so we keep them but mention them as a limitation.
------------------------------------------------------------------------------------------
-- Does is_default match the loan status?
SELECT loan_status_risk,
       SUM(is_default)      AS defaulted,
       COUNT(*) - SUM(is_default) AS not_defaulted
FROM raw.loans
GROUP BY loan_status_risk;
-- is_default = 1 only for "Defaulted" (56,364 loans). Written-off loans (14,185) count as
-- not defaulted, as Bondora defines it. The flag and the status agree.

-- =====================================================
-- B. OBJECTIVE 1: LOANS AND DEFAULT BY ISSUE YEAR
-- =====================================================

SELECT issued_year,
       COUNT(*) AS loans,
       ROUND(AVG(is_default) * 100, 1)                   AS default_rate_pct,
       ROUND(AVG(has_default_within_12_months) * 100, 1) AS default_12m_pct,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY months_on_book) AS median_months_on_book
FROM analytics.fct_loans
GROUP BY issued_year
ORDER BY issued_year;
-- Lending more than doubled: 81,556 (2023) -> 147,255 (2024) -> 182,054 (2025).
-- The default rate looks lower for 2025 (10.5%) than for 2023 (16.6%), but 2025 loans are
-- only about 12 months old, so they have had less time to default.
-- The 12-month default rate is fairer and is similar across years (10.9%, 8.2%, 8.9%).
-- So 2025 loans are not really safer; they are just younger.

-- =====================================================
-- C. OBJECTIVE 3: DEFAULTED VS NON-DEFAULTED LOANS
-- =====================================================

SELECT is_default,
       COUNT(*) AS loans,
       ROUND(AVG(combined_income)::numeric, 0)        AS avg_income,
       ROUND(AVG(issued_amount)::numeric, 0)          AS avg_amount,
       ROUND(AVG(initial_interest_rate)::numeric * 100, 1) AS avg_rate_pct,
       ROUND(AVG(initial_loan_duration)::numeric, 1)  AS avg_duration
FROM analytics.fct_loans
GROUP BY is_default;
-- Defaulted loans (56,364): lower income (2,302 vs 2,593 EUR), larger amount (2,236 vs 1,943 EUR),
-- higher interest rate (19.6% vs 18.0%) and longer duration (61 vs 58 months).

-- =====================================================
-- D. COMBINED CHECKS (WHY ARE SOME GROUPS RISKIER?)
-- =====================================================

-- D1. Country profile: why is Spain so high?
SELECT country,
       COUNT(*) AS loans,
       ROUND(AVG(is_default) * 100, 1) AS default_rate_pct,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY combined_income) AS median_income,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY issued_amount)   AS median_amount,
       ROUND(AVG(initial_interest_rate)::numeric * 100, 1)          AS avg_rate_pct,
       ROUND(AVG(CASE WHEN rating_group = 'Unrated' THEN 1 ELSE 0 END) * 100, 1)         AS unrated_pct,
       ROUND(AVG(CASE WHEN rating_group IN ('F','G','HR') THEN 1 ELSE 0 END) * 100, 1)  AS f_g_hr_pct
FROM analytics.fct_loans
GROUP BY country
ORDER BY default_rate_pct DESC;
-- Spain (51.5%): 98% of its loans are unrated, and the loans are large (median 2,870 EUR).
-- Bondora lends there almost without a rating, which explains much of the risk.
-- Latvia (31.4%): lowest income (median 1,227 EUR) and the highest interest rate (28.3%).
-- Denmark (29.7%): high income, but 31.5% of loans are rated F/G/HR.
-- Netherlands (8.6%): highest income (3,308 EUR) and lowest rate (9.9%) -> lowest risk.
-- So the country differences are mostly explained by rating, income and interest rate.

-- D2. Amount profile: why are 5,000+ loans safer than 2,000–4,999? 
SELECT amount_band,
       COUNT(*) AS loans,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY combined_income) AS median_income,
       ROUND(AVG(initial_interest_rate)::numeric * 100, 1)          AS avg_rate_pct,
       ROUND(AVG(CASE WHEN rating_group IN ('AA','A','B') THEN 1 ELSE 0 END) * 100, 1) AS good_rating_pct
FROM analytics.fct_loans
GROUP BY amount_band
ORDER BY amount_band;
-- Confirmed: loans of 5,000+ go to borrowers with higher income (median 2,571 vs 2,404 EUR),
-- better ratings (75% AA/A/B vs 43%) and lower interest (16.5% vs 18.2%).
-- Bondora only gives large loans to safer borrowers, so they default less than 2,000–4,999 loans.

-- D3. Rating x duration: which combination is riskiest?
SELECT rating_group,
       duration_band,
       COUNT(*) AS loans,
       ROUND(AVG(is_default) * 100, 1) AS default_rate_pct
FROM analytics.fct_loans
GROUP BY rating_group, duration_band
HAVING COUNT(*) >= 100
ORDER BY default_rate_pct DESC
LIMIT 10;

-- The riskiest combination is G-rated loans of 13–36 months (29.7%),
-- followed by unrated loans over 60 months (28.1%) and F-rated loans of 37–60 months (27.6%).
-- The safest: AA loans up to 12 months default at only 1.6%.
-- For ratings AA to F, 37–60-month loans default the most; for G, the risk is high at every duration.
-- So a bad rating combined with a long loan gives the highest risk.
-- (HAVING COUNT(*) >= 100 removes tiny groups such as HR.)
----------------------------------------------------------------------------------------------------------------
--Kpi_by_year
SELECT * FROM analytics.kpi_by_year;

-- kpi_by_year: one row per issue year (dbt model, built from fct_loans)
-- Lending more than doubled: 81,556 loans (2023) -> 147,255 (2024) -> 182,054 (2025).
-- Defaulted loans: 13,504 (2023) + 23,715 (2024) + 19,145 (2025) = 56,364 in total.
-- The default rate looks lower for 2025 (10.5%) than for 2023 (16.6%) and 2024 (16.1%),
-- but 2025 loans are younger, so they have had less time to default.
-- The 12-month default rate is the fair comparison (same 12 months for every loan):
-- 10.9% (2023), 8.2% (2024), 8.9% (2025), so the years are quite similar.
-- For 2025, only 156,588 of 182,054 loans (86%) are already 12 months old;
-- the rest are not counted in the 12-month rate yet.
-- The cancellation rate increase slightly: 3.5% (2023) -> 4.2% (2024) -> 4.3% (2025).
-- Conclusion: 2025 loans are not really safer; they are just younger.

-- =====================================================
-- E. KPI_CROSS_SEGMENT (dbt model): RATING x COUNTRY and RATING x DURATION
-- =====================================================

-- E1. Riskiest rating x country groups (only groups with 100+ loans)
SELECT value_1 AS rating, value_2 AS country, loans,
       default_rate_pct, avg_interest_rate_pct
FROM analytics.kpi_cross_segment
WHERE combination = 'rating_group x country'
  AND NOT is_small_group
ORDER BY default_rate_pct DESC
LIMIT 10;

-- The riskiest group is unrated loans in Spain: 1,549 loans with a default rate of 51.6%.
-- Next come G-rated (43.6%) and D-rated (35.4%) loans in Denmark.
-- 8 of the 10 riskiest groups are in Latvia, at almost every rating (A to G).
-- Even A-rated loans in Latvia default 30.0%, more than G-rated loans overall (26.5%).
-- So in Latvia the rating does not separate good and bad borrowers well.
-- Latvian loans also pay the highest interest (about 26-30%), while Denmark and Spain
-- pay only about 18-20%, so their high risk is not reflected in the interest rate.
-- Conclusion: the country adds risk on top of the rating.
-----------------------------------------------------------------------------------------------

-- E2. Riskiest rating x duration groups (only groups with 100+ loans)
SELECT value_1 AS rating, value_2 AS duration, loans,
       default_rate_pct, avg_interest_rate_pct
FROM analytics.kpi_cross_segment
WHERE combination = 'rating_group x duration_band'
  AND NOT is_small_group
ORDER BY default_rate_pct DESC
LIMIT 10;

-- The riskiest group is G-rated loans of 13-36 months (29.7%), followed by
-- unrated loans over 60 months (28.1%) and F-rated loans of 37-60 months (27.6%).
-- 6 of the 10 riskiest groups are 37-60-month loans, from rating C to G.
-- G-rated loans are risky at every duration: even up to 12 months they default 26.6%,
-- while short loans overall default only 5.3%.
-- The biggest groups matter most: C-rated 37-60-month loans (32,883 loans, 20.6%)
-- and D-rated 37-60-month loans (20,877 loans, 24.4%) produce many defaults.
-- The interest rate in these groups is only about 17-22%, so it rises little with the risk.
-- Conclusion: a weak rating combined with a long loan gives the highest risk.




