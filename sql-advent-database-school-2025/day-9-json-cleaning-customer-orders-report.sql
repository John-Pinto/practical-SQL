/*
Day 9 - https://databaseschool.com/series/advent-of-sql/videos/320

Challenge: Build a report using the orders table that shows the latest order for each customer, 
along with their requested shipping method, gift wrap choice (as true or false), 
and the risk flag in separate columns.
Order the report by the most recent order first so Evergreen Market can reach out to them ASAP.
*/

SELECT
	*
FROM
	ORDERS
LIMIT
	10;

SELECT
	O.CUSTOMER_ID,
	O.SHIPPING,
	O.GIFT_WRAP,
	O.RISK_FLAG
FROM
	(
		SELECT
			CUSTOMER_ID,
			CREATED_AT,
			ORDER_DATA -> 'shipping' ->> 'method' AS SHIPPING,
			(ORDER_DATA -> 'gift' ->> 'wrapped')::BOOLEAN AS GIFT_WRAP,
			ORDER_DATA -> 'risk' ->> 'flag' AS RISK_FLAG,
			ROW_NUMBER() OVER (
				PARTITION BY
					CUSTOMER_ID
				ORDER BY
					CREATED_AT DESC
			)
		FROM
			ORDERS
	) AS O
WHERE
	ROW_NUMBER = 1
ORDER BY
	CREATED_AT DESC;