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
	system_dispatches
LIMIT
	10;

SELECT
	*
FROM
	incoming_dispatches
LIMIT
	10;

WITH
	cummulative AS (
		SELECT
			system_id,
			dispatched_at,
			payload,
			'system' AS dispatch_origin
		FROM
			system_dispatches
		UNION
		SELECT
			system_id,
			dispatched_at,
			payload,
			'incoming' AS dispatch_origin
		FROM
			incoming_dispatches
	),
	cleaned AS (
		SELECT
			system_id,
			dispatched_at,
			payload ->> 'marker' AS payload_marker,
			payload ->> 'source' AS payload_source,
			dispatch_origin,
			ROW_NUMBER() OVER (
				PARTITION BY
					system_id
				ORDER BY
					dispatched_at DESC
			)
		FROM
			cummulative
		WHERE
			payload ->> 'source' = 'primary'
	)
SELECT
	system_id,
	dispatched_at,
	payload_marker
FROM
	cleaned
WHERE
	row_number = 1;