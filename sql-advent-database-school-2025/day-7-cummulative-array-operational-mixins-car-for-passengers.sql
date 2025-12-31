/*
Day 7 - https://databaseschool.com/series/advent-of-sql/videos/318

Challenge: Get the stewards a list of all the passengers and the cocoa car(s) 
they can be served from that has at least one of their favorite mixins.
Remember only the top three most-stocked cocoa cars remained operational, 
so the passengers must be served from one of those cars.
*/

SELECT
	*
FROM
	PASSENGERS
LIMIT
	10;

SELECT
	*
FROM
	COCOA_CARS
LIMIT
	10;

WITH
	OPERATIONAL_COCOA_CARS AS (
		SELECT
			*
		FROM
			COCOA_CARS
		ORDER BY
			TOTAL_STOCK DESC
		LIMIT
			3
	),
	PASSENGER_MIXINS AS (
		SELECT
			P.PASSENGER_NAME,
			P.FAVORITE_MIXINS,
			O.CAR_ID,
			O.AVAILABLE_MIXINS
		FROM
			OPERATIONAL_COCOA_CARS AS O
			INNER JOIN PASSENGERS AS P ON O.AVAILABLE_MIXINS && P.FAVORITE_MIXINS
	)
SELECT
	PASSENGER_NAME,
	ARRAY_AGG(CAR_ID) as operational_car
FROM
	PASSENGER_MIXINS
GROUP BY
	PASSENGER_NAME;