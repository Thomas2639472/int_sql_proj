WITH customer_status_and_cohort AS (
	SELECT
		DISTINCT ca.customerkey,
		cs.customer_status,
		ca.cohort
	FROM
		cohort_analysis ca
	LEFT JOIN customer_status cs ON
		cs.customerkey = ca.customerkey
	ORDER BY
		customerkey
),

count_of_active_by_cohort AS (
	SELECT
		customer_status,
		cohort,
		COUNT(*) AS num_customers
	FROM
		customer_status_and_cohort
	GROUP BY
		customer_status,
		cohort
	HAVING
		customer_status IS NOT NULL
	ORDER BY
		cohort
)

SELECT
	customer_status,
	cohort,
	num_customers,
	SUM(num_customers) OVER (
		PARTITION BY cohort
	ORDER BY
		cohort
	) AS total_customers,
	100 * num_customers / SUM(num_customers) OVER (
		PARTITION BY cohort
	ORDER BY
		cohort
	) AS status_percentage
FROM
	count_of_active_by_cohort