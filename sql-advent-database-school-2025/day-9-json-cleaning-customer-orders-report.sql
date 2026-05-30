/*
Day 9 - https://databaseschool.com/series/advent-of-sql/videos/320

Challenge: Build a report using the orders table that shows the latest order for each customer, 
along with their requested shipping method, gift wrap choice (as true or false), 
and the risk flag in separate columns.
Order the report by the most recent order first so Evergreen Market can reach out to them ASAP.
*/

SET
	SEARCH_PATH = SQL_ADVENT_2025;

SELECT
	*
FROM
	orders
LIMIT
	10;

SELECT
	o.customer_id,
	o.shipping,
	o.gift_wrap,
	o.risk_flag
FROM
	(
		SELECT
			customer_id,
			created_at,
			order_data -> 'shipping' ->> 'method' AS shipping,
			(order_data -> 'gift' ->> 'wrapped')::BOOLEAN AS gift_wrap,
			order_data -> 'risk' ->> 'flag' AS risk_flag,
			ROW_NUMBER() OVER (
				PARTITION BY
					customer_id
				ORDER BY
					created_at DESC
			)
		FROM
			orders
	) AS o
WHERE
	row_number = 1
ORDER BY
	created_at DESC;