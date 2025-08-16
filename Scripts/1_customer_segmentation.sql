WITH entire_ltv AS (
	SELECT
		SUM(total_ltv) AS entire_ltv
	FROM
		customer_ltv
	
)

SELECT
	cl.ltv_segment AS customer_segment,
	SUM(cl.total_ltv) AS total_ltv,
	100 * SUM(cl.total_ltv) / AVG(el.entire_ltv) AS ltv_percentage,
	COUNT(*) AS customer_count,
	SUM(cl.total_ltv) / COUNT(*) AS avg_ltv
FROM
	customer_ltv cl
CROSS JOIN entire_ltv el
GROUP BY ltv_segment
ORDER BY customer_segment DESC
