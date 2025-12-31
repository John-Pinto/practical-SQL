/*
Day 13 - https://databaseschool.com/series/advent-of-sql/videos/324

Challenge: Using the travel_manifests table, 
extract the passenger information from the XML data and produce a report that shows 
all of the departure times for "CARGO" vehicles that have more than 20 passengers booked. 
Include in the results:
The vehicle_id
The departure_time
The total number of passengers on that departure
Order the results by departure_time.
*/

SELECT
	*
FROM
	TRAVEL_MANIFESTS
LIMIT
	10;

WITH
	MANIFEST AS (
		SELECT
			VEHICLE_ID,
			DEPARTURE_TIME,
			CARDINALITY(
				XPATH('/manifest/passengers/passenger', MANIFEST_XML)
			) AS TOTAL_PASSENGERS
		FROM
			TRAVEL_MANIFESTS
		WHERE
			VEHICLE_ID ILIKE '%cargo%'
	)
SELECT
	VEHICLE_ID,
	DEPARTURE_TIME,
	SUM(TOTAL_PASSENGERS) AS TOTAL_PASSENGERS
FROM
	MANIFEST
GROUP BY
	1,
	2
HAVING
	SUM(TOTAL_PASSENGERS) > 20
ORDER BY
	DEPARTURE_TIME DESC;