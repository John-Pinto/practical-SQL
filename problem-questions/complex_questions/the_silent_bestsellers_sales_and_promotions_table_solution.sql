-- The Silent Bestsellers

-- Question
-- You work at a retail analytics company managing data for a chain of stores across multiple cities. 
-- The product team wants to identify "Silent Bestsellers" — 
-- products that are among the top 3 best-selling products by revenue in their category, 
-- but have never been promoted or discounted in any way.
-- The idea is simple — these products sell well purely on merit, with no marketing push. 
-- The business wants to reward these products with premium shelf placement.

-- Find all Silent Bestsellers and return:
-- product_id
-- category
-- total_revenue — total revenue across all stores and all time
-- revenue_rank — rank within their category by total revenue
-- stores_sold_in — number of distinct stores the product was sold in
-- first_sale_date — earliest sale date for this product
-- last_sale_date — most recent sale date for this product
-- order the result by product id, category and revenue rank.

-- Constraints & Traps:
-- A product is a Silent Bestseller if it ranks top 3 by total revenue within its category
-- A product is disqualified if it appears in the promotions table at any store, ever — 
-- even if the promotion was in a different store than where it sold well
-- Revenue = quantity * unit_price
-- If two products have the same revenue, use DENSE_RANK so both can qualify and 
-- ranking should be done only within qualified products.
-- A product must have been sold in at least 2 stores to qualify

SET
	SEARCH_PATH = PROBLEM_QUESTIONS;

SELECT
	*
FROM
	sales;

SELECT
	*
FROM
	promotions;

WITH
	qualified_product AS (
		SELECT
			s.product_id,
			COUNT(DISTINCT s.store_id) AS stores_sold_in
		FROM
			sales AS s
			LEFT JOIN promotions AS p ON s.product_id = p.product_id
		WHERE
			p.promotion_id IS NULL
		GROUP BY
			s.product_id
		HAVING
			COUNT(DISTINCT s.store_id) >= 2
	),
	qualified_product_revenue_agg AS (
		SELECT
			s.product_id,
			s.category,
			SUM(s.quantity * s.unit_price) AS total_revenue,
			DENSE_RANK() OVER (
				PARTITION BY
					s.category
				ORDER BY
					SUM(s.quantity * s.unit_price) DESC
			) AS revenue_rank,
			qp.stores_sold_in,
			MIN(s.sale_date) AS first_sale_date,
			MAX(s.sale_date) AS last_sale_date
		FROM
			qualified_product AS qp
			JOIN sales AS s ON qp.product_id = s.product_id
		GROUP BY
			s.product_id,
			s.category,
			qp.stores_sold_in
	)
SELECT
	*
FROM
	qualified_product_revenue_agg
WHERE
	revenue_rank <= 3
ORDER BY
	1 ASC,
	2 ASC,
	4 ASC;