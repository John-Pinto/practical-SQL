/*
Day 6 - https://databaseschool.com/series/advent-of-sql/videos/317

Challenge: Generate a report that returns the dates and families that have no delivery assigned after December 14th, 
using the families and deliveries_assigned.
Each row in the report should be a date and family name that represents the dates in which families don't have a 
delivery assigned yet.
Label the columns as unassigned_date and name. Order the results by unassigned_date and name, respectively, 
both in ascending order.
*/

SELECT
	*
FROM
	FAMILIES
LIMIT
	10;

SELECT
	*
FROM
	DELIVERIES_ASSIGNED
LIMIT
	10;

WITH
	GENERATE_DATES AS (
		SELECT
			GENERATE_SERIES('2025-12-15', '2025-12-25', INTERVAL '1 day')::DATE AS DATES
	),
	FAMILIES_WITH_DATES AS (
		SELECT
			*
		FROM
			FAMILIES
			CROSS JOIN GENERATE_DATES
	),
	UNASSIGNED_DELIVERIES AS (
		SELECT
			*
		FROM
			FAMILIES_WITH_DATES AS F
			LEFT JOIN DELIVERIES_ASSIGNED AS D ON F.ID = D.FAMILY_ID
			AND F.DATES = D.GIFT_DATE
		WHERE
			D.ID IS NULL
	)
SELECT
	DATES AS UNASSIGNED_DATE,
	FAMILY_NAME AS NAME
FROM
	UNASSIGNED_DELIVERIES
ORDER BY
	UNASSIGNED_DATE ASC,
	NAME ASC;