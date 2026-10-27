1. We changed the datatype (country, loan_staus, and loan_status_risk, customer_risk_rating) from string to category. They are labels with few unique values. So this saves memory and speeds up groupby.
2. We changed the datatype (Is_default, and has_default_within_12_months) from float64 to integer 8. They are really 0/1 flags. They show as float only because they have missing values.
3. **`is_default`** is missing for 7,713 rows (about 1%). For the default analysis, we work with the rows that have a value.
4. **`combined_income`** is missing for about 35% of rows.
5. **`customer_risk_rating`** is missing for about 43% of rows.
6. **`has_default_within_12_months`** is missing for about 23% of rows, most likely recent loans that haven’t had 12 months to show an outcome.
