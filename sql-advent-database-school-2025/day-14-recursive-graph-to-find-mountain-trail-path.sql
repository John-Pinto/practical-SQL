/*
Day 14 - https://databaseschool.com/series/advent-of-sql/videos/325

Challenge: Using the mountain network data, find all possible routes from Jake’s Lift to Maverick, 
no matter how long or winding, so the group can split up based on how much skiing they want to do.
The mountain is connected. The paths are many. 
Time to let recursion do the navigating.
Find all the possible routes from Jake's Lift to Maverick. 
None of the possible routes will take more than 12 connections.
*/

SELECT
	*
FROM
	MOUNTAIN_NETWORK;

WITH RECURSIVE
	MOUNTAIN_PATH AS (
		-- Base Condition
		SELECT
			1 AS SEGMENT_COUNT,
			'Jake''s Lift' AS CURRENT_NODE,
			'Jake''s Lift' AS ROUTE
		UNION ALL
		-- Recursive condition
		SELECT
			MP.SEGMENT_COUNT + 1,
			MN.TO_NODE,
			MP.ROUTE || ' -> ' || MN.TO_NODE
		FROM
			MOUNTAIN_NETWORK AS MN
			INNER JOIN MOUNTAIN_PATH AS MP ON MN.FROM_NODE = MP.CURRENT_NODE
		WHERE
			-- condition to stop recursion and to move forward not in a loop
			SEGMENT_COUNT <= 12
			AND ROUTE NOT LIKE '%' || MN.TO_NODE || '%' -- mn.to_node should be distinct for mp.route
	)
SELECT
	*
FROM
	MOUNTAIN_PATH
WHERE
	CURRENT_NODE ILIKE '%maverick%'