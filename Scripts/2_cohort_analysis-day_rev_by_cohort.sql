SELECT
	cohort,
	SUM(total_net_revenue) AS total_revenue_1st_day,
	COUNT(DISTINCT customerkey) AS total_customers,
	SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue_1st_day
FROM
	cohort_analysis
WHERE
	orderdate = first_purchase_date
GROUP BY
	cohort
ORDER BY
	cohort
;