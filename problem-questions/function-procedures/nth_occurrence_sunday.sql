-- Write a query to provide the date for the nth occurrence of Sunday in future from given date

SET
	SEARCH_PATH = PROBLEM_QUESTIONS;

DROP FUNCTION if EXISTS nth_sunday_occurrence (date, INT);

CREATE OR REPLACE FUNCTION nth_sunday_occurrence (date, INT) 
returns date AS 
$BODY$
SELECT 
	-- Getting the nearest sunday occurrence date
	($1 + ((7 - EXTRACT(DOW FROM $1)) || ' days')::INTERVAL) +
	-- Adding the nth occurrence to the found sunday date
	($2 - 1 || ' week')::INTERVAL
$BODY$ language sql;

SELECT
	nth_sunday_occurrence ('2026-1-2'::date, 4);