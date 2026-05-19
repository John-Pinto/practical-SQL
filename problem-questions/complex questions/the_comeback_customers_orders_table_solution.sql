-- The Comeback Customers

-- The Problem
-- You work at an e-commerce company. The marketing team wants to identify “Comeback Customers” — 
-- customers who had a period of inactivity (no orders for 60 or more days) and then came back to purchase again. 
-- The team wants to understand their buying behavior before and after the comeback.

-- The Ask
-- Find all comeback customers and return one row per customer:
-- customer_id
-- gap_days — the longest gap (in days) between any two consecutive orders.
-- orders_before_comeback — number of orders placed before the gap.
-- orders_after_comeback — number of orders placed after the gap.
-- spend_before_comeback — total amount spent before the gap.
-- spend_after_comeback — total amount spent after the gap.
-- comeback_date — the order date when they came back after the longest gap.

-- Constraints & Traps
-- Only consider customers who have placed at least 2 orders.
-- Gap is measured between consecutive orders sorted by date.
-- If a customer has multiple gaps ≥ 60 days, report only the longest gap.
-- If two gaps are equal in length, pick the earliest one.
-- Customers with no gap ≥ 60 days should not appear in the result.
-- orders_before_comeback and orders_after_comeback are split at the longest gap.

SELECT
	*
FROM
	orders;

WITH
	order_gap_calc AS (
		SELECT
			customer_id,
			order_date,
			order_amount,
			order_date - LAG(order_date) OVER (
				PARTITION BY
					customer_id
				ORDER BY
					order_date ASC
			) AS order_gap_days
		FROM
			orders
	),
	ranking_order_gap AS (
		SELECT
			customer_id,
			order_date,
			order_gap_days,
			ROW_NUMBER() OVER (
				PARTITION BY
					customer_id
				ORDER BY
					order_gap_days DESC,
					order_date ASC
			) AS gap_days_rank
		FROM
			order_gap_calc
		WHERE
			order_gap_days >= 60
	),
	comeback_order AS (
		SELECT
			customer_id,
			order_date,
			order_gap_days
		FROM
			ranking_order_gap
		WHERE
			gap_days_rank = 1
	)
SELECT
	o.customer_id,
	co.order_gap_days AS gap_days,
	COUNT(
		CASE
			WHEN o.order_date < co.order_date THEN 1
		END
	) AS orders_before_comeback,
	COUNT(
		CASE
			WHEN o.order_date >= co.order_date THEN 1
		END
	) AS orders_after_comeback,
	SUM(
		CASE
			WHEN o.order_date < co.order_date THEN o.order_amount
		END
	) AS spend_before_comeback,
	SUM(
		CASE
			WHEN o.order_date >= co.order_date THEN o.order_amount
		END
	) AS spend_after_comeback,
	co.order_date AS comeback_date
FROM
	orders AS o
	JOIN comeback_order AS co ON o.customer_id = co.customer_id
GROUP BY
	o.customer_id,
	co.order_gap_days,
	co.order_date
ORDER BY
	1 ASC;