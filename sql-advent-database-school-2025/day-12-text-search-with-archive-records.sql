/*
Day 12 - https://databaseschool.com/series/advent-of-sql/videos/323

Challenge: Using the archive_records table, search both the title and description fields for the term "fly". 
Make sure that you also match for words like "flying", "flight", etc. 
Boost the results where the term appears in the title and lastly, 
rank the results by relevance (most relevant first). 
Provide the elves the top 5 most relevant archived records back.
*/
SELECT
	*
FROM
	ARCHIVE_RECORDS
LIMIT
	10;

WITH
	RECORDS_VECTOR AS (
		SELECT
			*,
			SETWEIGHT(TO_TSVECTOR('english', TITLE), 'A') || SETWEIGHT(TO_TSVECTOR('english', DESCRIPTION), 'B') AS VECTORS
		FROM
			ARCHIVE_RECORDS
	)
SELECT
	ID,
	TITLE,
	DESCRIPTION,
	TS_RANK(VECTORS, TO_TSQUERY('english', 'fly:*')) AS RANK
FROM
	RECORDS_VECTOR
WHERE
	VECTORS @@ TO_TSQUERY('english', 'fly:*')
ORDER BY
	RANK DESC
LIMIT
	5;