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
	snowball_inventory;

SELECT
	*
FROM
	snowball_categories;

SELECT
	sc.official_category,
	SUM(si.quantity)
FROM
	snowball_categories AS sc
	LEFT JOIN snowball_inventory AS si ON si.category_name = sc.official_category
	AND si.quantity > 0
GROUP BY
	1
ORDER BY
	2 ASC;