/*
Day 3 - https://databaseschool.com/series/advent-of-sql/videos/314

Challenge: Using the hotline_messages table, update any record that has "sorry" (case insensitive) in the transcript and 
doesn't currently have a status assigned to have a status of "approved".
Then delete any records where the tag is "penguin prank", "time-loop advisory", "possible dragon", or "nonsense alert" or 
if the caller's name is "Test Caller".
After updating and deleting the records as described, write a final query that returns how many messages currently have a 
status of "approved" and how many still need to be reviewed (i.e., status is NULL).
*/

SELECT
	*
FROM
	hotline_messages
LIMIT
	100;

SELECT
	*
FROM
	hotline_messages
WHERE
	transcript ILIKE '%sorry%'
	AND status IS NULL;

UPDATE hotline_messages
SET
	status = 'approved'
WHERE
	transcript ILIKE '%sorry%';

SELECT
	*
FROM
	hotline_messages
WHERE
	tag ILIKE ANY (
		ARRAY[
			'%penguin%',
			'%time%loop%',
			'%dragon%',
			'%nonsense%'
		]
	)
	OR caller_name ILIKE '%test%';

DELETE FROM hotline_messages
WHERE
	tag ILIKE ANY (
		ARRAY[
			'%penguin%',
			'%time%loop%',
			'%dragon%',
			'%nonsense%'
		]
	)
	OR caller_name ILIKE '%test%';

SELECT
	SUM(
		CASE
			WHEN status = 'approved' THEN 1
			ELSE 0
		END
	) AS approved_count,
	SUM(
		CASE
			WHEN status IS NULL THEN 1
			ELSE 0
		END
	) AS needs_review
FROM
	hotline_messages;

SELECT
	COUNT(*) FILTER (
		WHERE
			status = 'approved'
	) AS approved_count,
	COUNT(*) FILTER (
		WHERE
			status IS NULL
	) AS needs_review
FROM
	hotline_messages;