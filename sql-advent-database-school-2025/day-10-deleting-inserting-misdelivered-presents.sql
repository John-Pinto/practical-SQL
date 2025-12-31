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

SELECT
	*
FROM
	DELIVERIES
LIMIT
	10;

SELECT
	*
FROM
	MISDELIVERED_PRESENTS
LIMIT
	10;

WITH
	CLEANING_DELIVERIES AS (
		DELETE FROM DELIVERIES
		WHERE
			DELIVERY_LOCATION ILIKE ANY (
				ARRAY['%Volcano%', '%Igloo%', '%Lighthouse%', '%Vibes%']
			)
		RETURNING
			*
	)
INSERT INTO
	MISDELIVERED_PRESENTS (
		ID,
		CHILD_NAME,
		DELIVERY_LOCATION,
		GIFT_NAME,
		SCHEDULED_AT,
		FLAGGED_AT,
		REASON
	)
SELECT
	ID,
	CHILD_NAME,
	DELIVERY_LOCATION,
	GIFT_NAME,
	SCHEDULED_AT,
	NOW() AS FLAGGED_AT,
	'Invalid delivery location' AS REASON
FROM
	CLEANING_DELIVERIES
ON CONFLICT (ID) DO NOTHING;