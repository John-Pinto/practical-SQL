/*
Day 11 - https://databaseschool.com/series/advent-of-sql/videos/322

Challenge: Calculate the 7-day rolling average behavior score for each child. 
Identify any child whose rolling average drops below 0. For those children with a rolling average below 0, 
return the child_id, child_name, behavior_date (this will be the latest date in the 7-day rolling average), 
and the calculated 7-day rolling average. Only include results with a behavior_date of December 7, 2025 or later, 
ensuring that each rolling average is based on a full 7 days of data.
Order the results by behavior_date and then child_name.
*/

SELECT
	*
FROM
	BEHAVIOR_LOGS
LIMIT
	10;

WITH
	ROLLING_AVG AS (
		SELECT
			*,
			ROUND(
				AVG(SCORE) OVER (
					PARTITION BY
						CHILD_ID
					ORDER BY
						BEHAVIOR_DATE ASC RANGE BETWEEN INTERVAL '6 days' PRECEDING
						AND CURRENT ROW
				),
				2
			) AS ROLLING_AVG_7_DAYS
		FROM
			BEHAVIOR_LOGS
	)
SELECT
	CHILD_ID,
	CHILD_NAME,
	BEHAVIOR_DATE,
	ROLLING_AVG_7_DAYS
FROM
	ROLLING_AVG
WHERE
	ROLLING_AVG_7_DAYS < 0
	AND BEHAVIOR_DATE >= '2025-12-07'
ORDER BY
	BEHAVIOR_DATE ASC,
	CHILD_NAME ASC;