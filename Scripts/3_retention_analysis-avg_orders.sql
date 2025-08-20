WITH avg_orders_per_year AS (
	SELECT
		cohort,
		ca.customerkey,
		(
			(
				SUM(num_orders)
			) / 
	(
				(
					(
						last_purchase_date - first_purchase_date
					)::INT + 365.25 / 2
				) / 365.25
			)::FLOAT
		) AS avg_orders_per_year
	FROM
		cohort_analysis ca
	LEFT JOIN customer_status cs ON
		cs.customerkey = ca.customerkey
	GROUP BY
		ca.customerkey,
		cohort,
		(
			last_purchase_date - first_purchase_date
		)::INT
	ORDER BY
		customerkey
)

SELECT
	cohort,
	AVG(avg_orders_per_year) AS avg_orders_per_year_per_customer
FROM
	avg_orders_per_year
WHERE
	cohort < EXTRACT(YEAR FROM (SELECT MAX(orderdate) FROM sales))
GROUP BY
	cohort
ORDER BY
	cohort
-- NOTE: the time range is the time between last purchase date, first purchase date, plus an additional 6 months (time where the customer is still considered "active")