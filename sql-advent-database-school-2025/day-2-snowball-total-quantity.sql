/*
Day 2 - https://databaseschool.com/series/advent-of-sql/videos/313:

Challenge: Using the snowball_inventory and snowball_categories tables,
write a query that returns valid snowball categories with the count of valid snowballs per category.
Your final table should have the columns official_category and total_usable_snowballs. 
Sort the output from fewest to most total_usable_snowballs.
*/

SELECT
	*
FROM
	SNOWBALL_INVENTORY;

SELECT
	*
FROM
	SNOWBALL_CATEGORIES;

SELECT
	SC.OFFICIAL_CATEGORY,
	SUM(SI.QUANTITY)
FROM
	SNOWBALL_CATEGORIES AS SC
	LEFT JOIN SNOWBALL_INVENTORY AS SI ON SI.CATEGORY_NAME = SC.OFFICIAL_CATEGORY
	AND SI.QUANTITY > 0
GROUP BY
	1
ORDER BY
	2 ASC;