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
	HOTLINE_MESSAGES
LIMIT
	100;

SELECT
	*
FROM
	HOTLINE_MESSAGES
WHERE
	TRANSCRIPT ILIKE '%sorry%'
	AND STATUS IS NULL;

UPDATE HOTLINE_MESSAGES
SET
	STATUS = 'approved'
WHERE
	TRANSCRIPT ILIKE '%sorry%';

SELECT
	*
FROM
	HOTLINE_MESSAGES
WHERE
	TAG ILIKE ANY (
		ARRAY[
			'%penguin%',
			'%time%loop%',
			'%dragon%',
			'%nonsense%'
		]
	)
	OR CALLER_NAME ILIKE '%test%';

DELETE FROM HOTLINE_MESSAGES
WHERE
	TAG ILIKE ANY (
		ARRAY[
			'%penguin%',
			'%time%loop%',
			'%dragon%',
			'%nonsense%'
		]
	)
	OR CALLER_NAME ILIKE '%test%';

SELECT
	SUM(
		CASE
			WHEN STATUS = 'approved' THEN 1
			ELSE 0
		END
	) AS APPROVED_COUNT,
	SUM(
		CASE
			WHEN STATUS IS NULL THEN 1
			ELSE 0
		END
	) AS NEEDS_REVIEW
FROM
	HOTLINE_MESSAGES;

SELECT
	COUNT(*) FILTER (
		WHERE
			STATUS = 'approved'
	) AS APPROVED_COUNT,
	COUNT(*) FILTER (
		WHERE
			STATUS IS NULL
	) AS NEEDS_REVIEW
FROM
	HOTLINE_MESSAGES;