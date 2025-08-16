SELECT
	TO_CHAR(orderdate, 'YYYY-MM') AS order_month,
	SUM(total_net_revenue) AS monthly_revenue,
	COUNT(DISTINCT customerkey) AS total_customers
FROM
	cohort_analysis
GROUP BY
	order_month
;