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
	behavior_logs
LIMIT
	10;

WITH
	rolling_avg AS (
		SELECT
			*,
			ROUND(
				AVG(score) OVER (
					PARTITION BY
						child_id
					ORDER BY
						behavior_date ASC RANGE BETWEEN INTERVAL '6 days' preceding
						AND current ROW
				),
				2
			) AS rolling_avg_7_days
		FROM
			behavior_logs
	)
SELECT
	child_id,
	child_name,
	behavior_date,
	rolling_avg_7_days
FROM
	rolling_avg
WHERE
	rolling_avg_7_days < 0
	AND behavior_date >= '2025-12-07'
ORDER BY
	behavior_date ASC,
	child_name ASC;