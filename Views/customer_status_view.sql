-- public.customer_status source

CREATE OR REPLACE
VIEW public.customer_status
AS WITH customer_lpd AS (
	SELECT
		DISTINCT s.customerkey,
		ca.cleaned_name,
		max(s.orderdate) OVER (
			PARTITION BY s.customerkey
		) AS last_purchase_date,
		ca.first_purchase_date
	FROM
		sales s
	LEFT JOIN cohort_analysis ca ON
		ca.customerkey = s.customerkey
	ORDER BY
		s.customerkey
)
SELECT
	customerkey,
	cleaned_name,
	last_purchase_date,
	CASE
		WHEN (
			(
				(
					SELECT
						max(sales.orderdate) AS max
					FROM
						sales
				)
			)::timestamp WITHOUT time ZONE - last_purchase_date::timestamp WITHOUT time ZONE
		) < '6 mons'::INTERVAL THEN 'Active'::text
		ELSE 'Churned'::text
	END AS customer_status
FROM
	customer_lpd
WHERE
	(
		(
			(
				SELECT
					max(sales.orderdate) AS max
				FROM
					sales
			)
		)::timestamp WITHOUT time ZONE - first_purchase_date::timestamp WITHOUT time ZONE
	) > '6 mons'::INTERVAL
ORDER BY
	first_purchase_date DESC;