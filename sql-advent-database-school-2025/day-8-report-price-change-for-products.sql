/*
Day 8 - https://databaseschool.com/series/advent-of-sql/videos/319

Challenge: Generate a report, using the products and price_changes tables for 
leadership that returns the product_name, current_price, previous_price, 
and the difference between the current and previous prices.
*/

SELECT
	*
FROM
	products
LIMIT
	10;

SELECT
	*
FROM
	price_changes
LIMIT
	10;

WITH
	price_change_diff AS (
		SELECT
			*,
			LEAD(price) OVER w AS previous_price,
			ROW_NUMBER() OVER w
		FROM
			price_changes
		WINDOW
			w AS (
				PARTITION BY
					product_id
				ORDER BY
					effective_timestamp DESC
			)
	)
SELECT
	p.product_name,
	pc.effective_timestamp,
	pc.price AS current_price,
	pc.previous_price,
	pc.price - pc.previous_price AS difference
FROM
	price_change_diff AS pc
	LEFT JOIN products AS p ON pc.product_id = p.product_id
WHERE
	row_number = 1;