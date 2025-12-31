/*
Day 4 - https://databaseschool.com/series/advent-of-sql/videos/315

Challenge:
Using the official_shifts and last_minute_signups tables, create a combined de-duplicated volunteer list.
Ensure the list has standardized role labels of Stage Setup, Cocoa Station, Parking Support, Choir Assistant, Snow Shoveling, Handwarmer Handout.
Make sure that the timeslot formats follow John's official shifts format.
*/
SELECT
	*
FROM
	OFFICIAL_SHIFTS
LIMIT
	100;

SELECT
	*
FROM
	LAST_MINUTE_SIGNUPS
LIMIT
	100;

WITH
	CLEANED_OFFICIAL_SHIFTS AS (
		SELECT
			*,
			CASE ROLE
				WHEN 'stage_setup' THEN 'Stage Setup'
				WHEN 'cocoa_station' THEN 'Cocoa Station'
				WHEN 'parking_support' THEN 'Parking Support'
				WHEN 'choir_assistant' THEN 'Choir Assistant'
				ELSE 'missing'
			END AS CLEANED_ROLE
		FROM
			OFFICIAL_SHIFTS
	),
	CLEANED_LAST_MINUTE_SIGNUPS AS (
		SELECT
			*,
			CASE
				WHEN ASSIGNED_TASK ILIKE '%stage%' THEN 'Stage Setup'
				WHEN ASSIGNED_TASK ILIKE '%cocoa%' THEN 'Cocoa Station'
				WHEN ASSIGNED_TASK ILIKE '%parking%' THEN 'Parking Support'
				WHEN ASSIGNED_TASK ILIKE '%choir%' THEN 'Choir Assistant'
				WHEN ASSIGNED_TASK ILIKE '%handwarmer%' THEN 'Handwarmer Handout'
				WHEN ASSIGNED_TASK ILIKE '%shovel%' THEN 'Snow Shoveling'
				ELSE 'missing'
			END AS CLEANED_TASK,
			CASE
				WHEN TIME_SLOT ILIKE '2%p%m%' THEN '2:00 PM'
				WHEN TIME_SLOT ILIKE '10%a%m%' THEN '10:00 AM'
				WHEN TIME_SLOT ILIKE '%noon%' THEN '12:00 PM'
				ELSE 'missing'
			END AS CLEANED_TIME_SLOT
		FROM
			LAST_MINUTE_SIGNUPS
	)
SELECT
	VOLUNTEER_NAME,
	CLEANED_ROLE AS ROLE,
	SHIFT_TIME
FROM
	CLEANED_OFFICIAL_SHIFTS
UNION
SELECT
	VOLUNTEER_NAME,
	CLEANED_TASK AS ROLE,
	CLEANED_TIME_SLOT AS SHIFT_TIME
FROM
	CLEANED_LAST_MINUTE_SIGNUPS
order by 1;