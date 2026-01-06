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
	archive_records
LIMIT
	10;

WITH
	records_vector AS (
		SELECT
			*,
			SETWEIGHT(TO_TSVECTOR('english', title), 'A') || SETWEIGHT(TO_TSVECTOR('english', description), 'B') AS vectors
		FROM
			archive_records
	)
SELECT
	id,
	title,
	description,
	TS_RANK(vectors, TO_TSQUERY('english', 'fly:*')) AS rank
FROM
	records_vector
WHERE
	vectors @@ TO_TSQUERY('english', 'fly:*')
ORDER BY
	rank DESC
LIMIT
	5;