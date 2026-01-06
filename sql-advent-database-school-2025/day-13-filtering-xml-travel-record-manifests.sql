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
	travel_manifests
LIMIT
	10;

WITH
	manifest AS (
		SELECT
			vehicle_id,
			departure_time,
			CARDINALITY(
				XPATH('/manifest/passengers/passenger', manifest_xml)
			) AS total_passengers
		FROM
			travel_manifests
		WHERE
			vehicle_id ILIKE '%cargo%'
	)
SELECT
	vehicle_id,
	departure_time,
	SUM(total_passengers) AS total_passengers
FROM
	manifest
GROUP BY
	1,
	2
HAVING
	SUM(total_passengers) > 20
ORDER BY
	departure_time DESC;