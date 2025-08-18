SELECT
	cohort,
	SUM(total_net_revenue) AS total_revenue_1st_year,
	COUNT(DISTINCT customerkey) AS total_customers,
	SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue_1st_year
FROM
	cohort_analysis
WHERE
	orderdate BETWEEN first_purchase_date AND first_purchase_date + INTERVAL '1 year'
GROUP BY
	cohort
HAVING
	cohort < EXTRACT(YEAR FROM (SELECT MAX(orderdate) FROM cohort_analysis))
	-- this just remove the year that is "current" in the data as it is not a full year
ORDER BY
	cohort
;