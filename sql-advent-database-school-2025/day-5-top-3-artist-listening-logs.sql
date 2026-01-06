/*
Day 5 - https://databaseschool.com/series/advent-of-sql/videos/316

Challenge: Write a query that returns the top 3 artists per user. Order the results by the most played.
*/

SELECT
	*
FROM
	listening_logs
LIMIT
	100;

SELECT
	*
FROM
	(
		SELECT
			user_name,
			artist,
			COUNT(*) AS play_count,
			DENSE_RANK() OVER (
				PARTITION BY
					user_name
				ORDER BY
					COUNT(*) DESC,
					artist ASC
			) AS rank
		FROM
			listening_logs
		GROUP BY
			1,
			2
	)
WHERE
	rank <= 3;