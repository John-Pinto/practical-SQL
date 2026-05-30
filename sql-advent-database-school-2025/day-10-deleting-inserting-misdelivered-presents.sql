/*
Day 10 - https://databaseschool.com/series/advent-of-sql/videos/321

Challenge: Clean-up the deliveries table to remove any records where the delivery_location is 
'Volcano Rim', 'Drifting Igloo', 'Abandoned Lighthouse', 'The Vibes'.
Move those records to the misdelivered_presents with all the same columns as deliveries plus a 
flagged_at column with the current time and a reason column with "Invalid delivery location" 
listed as the reason for each moved record.
Make sure your final step shows the misdelivered_presents records that you just moved 
(i.e. don't include any existing records from the misdelivered_presents table).
*/

SET
	SEARCH_PATH = SQL_ADVENT_2025;

SELECT
	*
FROM
	deliveries
LIMIT
	10;

SELECT
	*
FROM
	misdelivered_presents
LIMIT
	10;

WITH
	cleaning_deliveries AS (
		DELETE FROM deliveries
		WHERE
			delivery_location ILIKE ANY (
				ARRAY['%Volcano%', '%Igloo%', '%Lighthouse%', '%Vibes%']
			)
		RETURNING
			*
	)
INSERT INTO
	misdelivered_presents (
		id,
		child_name,
		delivery_location,
		gift_name,
		scheduled_at,
		flagged_at,
		reason
	)
SELECT
	id,
	child_name,
	delivery_location,
	gift_name,
	scheduled_at,
	NOW() AS flagged_at,
	'Invalid delivery location' AS reason
FROM
	cleaning_deliveries
ON CONFLICT (id) DO NOTHING;