/*
Day 6 - https://databaseschool.com/series/advent-of-sql/videos/317

Challenge: Generate a report that returns the dates and families that have no delivery assigned after December 14th, 
using the families and deliveries_assigned.
Each row in the report should be a date and family name that represents the dates in which families don't have a 
delivery assigned yet.
Label the columns as unassigned_date and name. Order the results by unassigned_date and name, respectively, 
both in ascending order.
*/

SET
	SEARCH_PATH = SQL_ADVENT_2025;

SELECT
	*
FROM
	families
LIMIT
	10;

SELECT
	*
FROM
	deliveries_assigned
LIMIT
	10;

WITH
	generate_dates AS (
		SELECT
			GENERATE_SERIES('2025-12-15', '2025-12-25', INTERVAL '1 day')::date AS dates
	),
	families_with_dates AS (
		SELECT
			*
		FROM
			families
			CROSS JOIN generate_dates
	),
	unassigned_deliveries AS (
		SELECT
			*
		FROM
			families_with_dates AS f
			LEFT JOIN deliveries_assigned AS d ON f.id = d.family_id
			AND f.dates = d.gift_date
		WHERE
			d.id IS NULL
	)
SELECT
	dates AS unassigned_date,
	family_name AS name
FROM
	unassigned_deliveries
ORDER BY
	unassigned_date ASC,
	name ASC;