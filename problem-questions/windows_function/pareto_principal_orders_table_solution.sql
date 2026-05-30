-- write a query to find the products that obey the pareto principal using the sales in the orders table.
-- Find the 20 percent products that make 80 percent of the sales.

SET
	SEARCH_PATH = PROBLEM_QUESTIONS;

SELECT
	*
FROM
	orders;

WITH
	total_product_sales AS (
		SELECT
			product_id,
			SUM(sales) AS product_sales
		FROM
			orders
		GROUP BY
			product_id
		ORDER BY
			2 DESC
	),
	sales_calculation AS (
		SELECT
			product_id,
			product_sales,
			SUM(product_sales) OVER (
				ORDER BY
					product_sales DESC ROWS BETWEEN unbounded preceding
					AND current ROW
			) AS running_sales,
			(SUM(product_sales) OVER ()) * 0.8 AS total_sales_80_percent
		FROM
			total_product_sales
	)
SELECT
	*
FROM
	sales_calculation
WHERE
	running_sales <= total_sales_80_percent;