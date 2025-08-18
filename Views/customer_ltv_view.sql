-- public.customer_ltv source

CREATE OR REPLACE
VIEW public.customer_ltv
AS WITH customer_ltv AS (
	SELECT
		cohort_analysis.customerkey,
		cohort_analysis.cleaned_name,
		sum(cohort_analysis.total_net_revenue) AS total_ltv
	FROM
		cohort_analysis
	GROUP BY
		cohort_analysis.cleaned_name,
		cohort_analysis.customerkey
),
ltv_percentiles AS (
	SELECT
		percentile_cont(0.25::double PRECISION) WITHIN GROUP (
		ORDER BY
			customer_ltv.total_ltv
		) AS p25,
		percentile_cont(0.50::double PRECISION) WITHIN GROUP (
		ORDER BY
			customer_ltv.total_ltv
		) AS p50,
		percentile_cont(0.75::double PRECISION) WITHIN GROUP (
		ORDER BY
			customer_ltv.total_ltv
		) AS p75
	FROM
		customer_ltv
)
SELECT
	c.customerkey,
	c.cleaned_name,
	c.total_ltv,
	CASE
		WHEN c.total_ltv < lp.p25 THEN '1 - Low-Value'::text
		WHEN c.total_ltv >= lp.p25
		AND c.total_ltv < lp.p75 THEN '2 - Mid-Value'::text
		ELSE '3 - High-Value'::text
	END AS ltv_segment
FROM
	customer_ltv c
CROSS JOIN ltv_percentiles lp
ORDER BY
	c.cleaned_name;