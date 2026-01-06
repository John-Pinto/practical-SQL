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
	official_shifts
LIMIT
	100;

SELECT
	*
FROM
	last_minute_signups
LIMIT
	100;

WITH
	cleaned_official_shifts AS (
		SELECT
			*,
			CASE role
				WHEN 'stage_setup' THEN 'Stage Setup'
				WHEN 'cocoa_station' THEN 'Cocoa Station'
				WHEN 'parking_support' THEN 'Parking Support'
				WHEN 'choir_assistant' THEN 'Choir Assistant'
				ELSE 'missing'
			END AS cleaned_role
		FROM
			official_shifts
	),
	cleaned_last_minute_signups AS (
		SELECT
			*,
			CASE
				WHEN assigned_task ILIKE '%stage%' THEN 'Stage Setup'
				WHEN assigned_task ILIKE '%cocoa%' THEN 'Cocoa Station'
				WHEN assigned_task ILIKE '%parking%' THEN 'Parking Support'
				WHEN assigned_task ILIKE '%choir%' THEN 'Choir Assistant'
				WHEN assigned_task ILIKE '%handwarmer%' THEN 'Handwarmer Handout'
				WHEN assigned_task ILIKE '%shovel%' THEN 'Snow Shoveling'
				ELSE 'missing'
			END AS cleaned_task,
			CASE
				WHEN time_slot ILIKE '2%p%m%' THEN '2:00 PM'
				WHEN time_slot ILIKE '10%a%m%' THEN '10:00 AM'
				WHEN time_slot ILIKE '%noon%' THEN '12:00 PM'
				ELSE 'missing'
			END AS cleaned_time_slot
		FROM
			last_minute_signups
	)
SELECT
	volunteer_name,
	cleaned_role AS role,
	shift_time
FROM
	cleaned_official_shifts
UNION
SELECT
	volunteer_name,
	cleaned_task AS role,
	cleaned_time_slot AS shift_time
FROM
	cleaned_last_minute_signups
ORDER BY
	1;