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
	mountain_network;

WITH RECURSIVE
	mountain_path AS (
		-- Base Condition
		SELECT
			1 AS segment_count,
			'Jake''s Lift' AS current_node,
			'Jake''s Lift' AS route
		UNION ALL
		-- Recursive condition
		SELECT
			mp.segment_count + 1,
			mn.to_node,
			mp.route || ' -> ' || mn.to_node
		FROM
			mountain_network AS mn
			INNER JOIN mountain_path AS mp ON mn.from_node = mp.current_node
		WHERE
			-- condition to stop recursion and to move forward not in a loop
			segment_count <= 12
			AND route NOT LIKE '%' || mn.to_node || '%' -- mn.to_node should be distinct for mp.route
	)
SELECT
	*
FROM
	mountain_path
WHERE
	current_node ILIKE '%maverick%'