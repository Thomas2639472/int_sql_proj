WITH cohort_total_orders AS (
	SELECT
		cohort,
		SUM(num_orders) AS total_orders_first_year,
		COUNT(DISTINCT customerkey) AS total_customers
	FROM
		cohort_analysis
	WHERE
		orderdate BETWEEN first_purchase_date AND first_purchase_date + INTERVAL '1 year'
	GROUP BY
		cohort
	HAVING
		cohort < EXTRACT(YEAR FROM (SELECT MAX(orderdate) FROM cohort_analysis))
		-- this just remove the year that is "current" in the data as it is not a full year
)

SELECT
	cohort,
	total_orders_first_year,
	total_orders_first_year / total_customers AS customer_orders_1st_year
FROM
	cohort_total_orders