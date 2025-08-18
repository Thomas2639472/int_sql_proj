-- public.cohort_analysis source

CREATE OR REPLACE
VIEW public.cohort_analysis
AS WITH customer_cohort AS (
	SELECT
		DISTINCT sales.customerkey,
		min(sales.orderdate) OVER (
			PARTITION BY sales.customerkey
		ORDER BY
			sales.customerkey
		) AS first_purchase_date,
		EXTRACT(YEAR FROM min(sales.orderdate) OVER (PARTITION BY sales.customerkey ORDER BY sales.customerkey)) AS cohort
	FROM
		sales
	ORDER BY
		sales.customerkey
)
SELECT
	avg(s.customerkey)::bigint AS customerkey,
	s.orderdate,
	sum(s.quantity::double PRECISION * s.unitprice / s.exchangerate) AS total_net_revenue,
	sum(s.orderkey / s.orderkey) AS num_orders,
	max(cc.first_purchase_date) AS first_purchase_date,
	max(cc.cohort) AS cohort,
	max(c.countryfull::text)::CHARACTER VARYING(100) AS countryfull,
	max(c.age) AS age,
	max(concat(TRIM(BOTH FROM c.givenname), ' ', TRIM(BOTH FROM c.surname))) AS cleaned_name
FROM
	sales s
LEFT JOIN customer_cohort cc ON
	cc.customerkey = s.customerkey
LEFT JOIN customer c ON
	c.customerkey = s.customerkey
GROUP BY
	s.orderkey,
	s.orderdate
ORDER BY
	(
		avg(s.customerkey)::bigint
	);