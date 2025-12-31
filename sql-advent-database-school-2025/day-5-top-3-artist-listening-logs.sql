/*
Day 5 - https://databaseschool.com/series/advent-of-sql/videos/316

Challenge: Write a query that returns the top 3 artists per user. Order the results by the most played.
*/
SELECT
	*
FROM
	LISTENING_LOGS
LIMIT
	100;

SELECT
	*
FROM
	(
		SELECT
			USER_NAME,
			ARTIST,
			COUNT(*) AS PLAY_COUNT,
			DENSE_RANK() OVER (
				PARTITION BY
					USER_NAME
				ORDER BY
					COUNT(*) DESC,
					ARTIST ASC
			) AS RANK
		FROM
			LISTENING_LOGS
		GROUP BY
			1,
			2
	)
WHERE
	RANK <= 3;