WITH total_orders_by_ltv_segment AS (
	SELECT
		ltv_segment,
		SUM(num_orders) AS total_orders
	FROM
		cohort_analysis ca
	LEFT JOIN customer_ltv cl ON
		cl.customerkey = ca.customerkey
	GROUP BY
		ltv_segment
)

SELECT
	ltv_segment,
	total_orders,
	100 * total_orders / (
		SELECT
			SUM(num_orders) AS total_orders
		FROM
			cohort_analysis
	) AS pct_of_total_orders
FROM
	total_orders_by_ltv_segment