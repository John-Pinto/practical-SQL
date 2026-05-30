/*
Day 7 - https://databaseschool.com/series/advent-of-sql/videos/318

Challenge: Get the stewards a list of all the passengers and the cocoa car(s) 
they can be served from that has at least one of their favorite mixins.
Remember only the top three most-stocked cocoa cars remained operational, 
so the passengers must be served from one of those cars.
*/

SET
	SEARCH_PATH = SQL_ADVENT_2025;

SELECT
	*
FROM
	passengers
LIMIT
	10;

SELECT
	*
FROM
	cocoa_cars
LIMIT
	10;

WITH
	operational_cocoa_cars AS (
		SELECT
			*
		FROM
			cocoa_cars
		ORDER BY
			total_stock DESC
		LIMIT
			3
	),
	passenger_mixins AS (
		SELECT
			p.passenger_name,
			p.favorite_mixins,
			o.car_id,
			o.available_mixins
		FROM
			operational_cocoa_cars AS o
			INNER JOIN passengers AS p ON o.available_mixins && p.favorite_mixins
	)
SELECT
	passenger_name,
	ARRAY_AGG(car_id) AS operational_car
FROM
	passenger_mixins
GROUP BY
	passenger_name;