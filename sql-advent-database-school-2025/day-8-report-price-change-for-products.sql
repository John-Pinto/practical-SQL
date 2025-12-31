/*
Day 8 - https://databaseschool.com/series/advent-of-sql/videos/319

Challenge: Generate a report, using the products and price_changes tables for 
leadership that returns the product_name, current_price, previous_price, 
and the difference between the current and previous prices.
*/

SELECT
	*
FROM
	PRODUCTS
LIMIT
	10;

SELECT
	*
FROM
	PRICE_CHANGES
LIMIT
	10;

WITH
	PRICE_CHANGE_DIFF AS (
		SELECT
			*,
			LEAD(PRICE) OVER w AS PREVIOUS_PRICE,
			row_number() over w
		FROM
			PRICE_CHANGES
		WINDOW
			W AS (
				PARTITION BY
					PRODUCT_ID
				ORDER BY
					EFFECTIVE_TIMESTAMP DESC
			)
	)
SELECT
	P.PRODUCT_NAME,
	PC.EFFECTIVE_TIMESTAMP,
	PC.PRICE AS CURRENT_PRICE,
	PC.PREVIOUS_PRICE,
	PC.PRICE - PC.PREVIOUS_PRICE AS DIFFERENCE
FROM
	PRICE_CHANGE_DIFF AS PC
	LEFT JOIN PRODUCTS AS P ON PC.PRODUCT_ID = P.PRODUCT_ID
where row_number = 1;