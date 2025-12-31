/*
Day 1 - https://databaseschool.com/series/advent-of-sql/videos/309:

Challenge: Using the wish_list table, count how many times each cleaned toy name appears, from most requested to least requested.
Return the results in two columns: wish and count.
Make sure the wish results have no extra leading or trailing spaces and are all lowercase.
*/

SELECT
	TRIM(LOWER(RAW_WISH)) AS RAW_WISH,
	COUNT(*)
FROM
	WISH_LIST
GROUP BY
	1
ORDER BY
	2 DESC;