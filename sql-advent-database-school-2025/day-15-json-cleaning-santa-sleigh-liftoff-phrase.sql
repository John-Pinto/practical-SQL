/*
Day 15 - https://databaseschool.com/series/advent-of-sql/videos/326

Challenge: Reconstruct the final confirmation phrase to text Santa 
based on the elves’ hazy recollection of how they solved this problem before.
Your final result should include the marker_letter for each system, 
using only the most recent dispatch from a primary source. 
Once the correct dispatch has been identified for every system, 
combine the results and order them by dispatched_at in ascending order 
to reveal the confirmation phrase.
The sleigh won’t launch without it.
*/

SELECT
	*
FROM
	SYSTEM_DISPATCHES
LIMIT
	10;

SELECT
	*
FROM
	INCOMING_DISPATCHES
LIMIT
	10;

WITH
	CUMMULATIVE AS (
		SELECT
			SYSTEM_ID,
			DISPATCHED_AT,
			PAYLOAD,
			'system' AS DISPATCH_ORIGIN
		FROM
			SYSTEM_DISPATCHES
		UNION
		SELECT
			SYSTEM_ID,
			DISPATCHED_AT,
			PAYLOAD,
			'incoming' AS DISPATCH_ORIGIN
		FROM
			INCOMING_DISPATCHES
	),
	CLEANED AS (
		SELECT
			SYSTEM_ID,
			DISPATCHED_AT,
			PAYLOAD ->> 'marker' AS PAYLOAD_MARKER,
			PAYLOAD ->> 'source' AS PAYLOAD_SOURCE,
			DISPATCH_ORIGIN,
			ROW_NUMBER() OVER (
				PARTITION BY
					SYSTEM_ID
				ORDER BY
					DISPATCHED_AT DESC
			)
		FROM
			CUMMULATIVE
		WHERE
			PAYLOAD ->> 'source' = 'primary'
	)
SELECT
	SYSTEM_ID,
	DISPATCHED_AT,
	PAYLOAD_MARKER
FROM
	CLEANED
WHERE
	ROW_NUMBER = 1;