-- https://8weeksqlchallenge.com/case-study-1/
-- Case Study Questions
-- Each of the following case study questions can be answered using a single SQL statement:
SET
	search_path = dannys_diner
;

SELECT
	*
FROM
	sales
;

SELECT
	*
FROM
	menu
;

SELECT
	*
FROM
	members
;

-- 1. What is the total amount each customer spent at the restaurant?
SELECT
	s.customer_id,
	SUM(m.price) AS total_amount
FROM
	sales AS s
	INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY
	s.customer_id
ORDER BY
	total_amount DESC
;

-- 2. How many days has each customer visited the restaurant?
SELECT
	customer_id,
	COUNT(DISTINCT order_date) AS visited_days
FROM
	sales
GROUP BY
	customer_id
ORDER BY
	visited_days DESC
;

-- 3. What was the first item from the menu purchased by each customer?
WITH
	customers_first_order AS (
		SELECT
			s.customer_id,
			s.order_date,
			m.product_name,
			DENSE_RANK() OVER (
				PARTITION BY
					s.customer_id
				ORDER BY
					s.order_date ASC
			) AS order_rank
		FROM
			sales AS s
			INNER JOIN menu AS m ON s.product_id = m.product_id
	)
SELECT
	customer_id,
	order_date,
	product_name
FROM
	customers_first_order
WHERE
	order_rank = 1
;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT
	m.product_id,
	m.product_name,
	COUNT(*) AS total_sold
FROM
	menu AS m
	INNER JOIN sales AS s ON m.product_id = s.product_id
GROUP BY
	m.product_id,
	m.product_name
ORDER BY
	total_sold DESC
LIMIT
	1
;

SELECT
	s.customer_id,
	m.product_name,
	COUNT(*)
FROM
	menu AS m
	INNER JOIN sales AS s ON m.product_id = s.product_id
	AND m.product_id = 3
GROUP BY
	s.customer_id,
	m.product_name
;

-- 5. Which item was the most popular for each customer?
WITH
	most_popular_item AS (
		SELECT
			s.customer_id,
			m.product_name,
			DENSE_RANK() OVER (
				PARTITION BY
					s.customer_id
				ORDER BY
					COUNT(*) DESC
			) AS popularity_rank
		FROM
			sales AS s
			INNER JOIN menu AS m ON s.product_id = m.product_id
		GROUP BY
			s.customer_id,
			m.product_name
	)
SELECT
	customer_id,
	product_name
FROM
	most_popular_item
WHERE
	popularity_rank = 1
;

-- 6. Which item was purchased first by the customer after they became a member?
WITH
	order_after_membership AS (
		SELECT
			s.customer_id,
			s.order_date,
			mem.join_date,
			m.product_name,
			DENSE_RANK() OVER (
				PARTITION BY
					s.customer_id
				ORDER BY
					s.order_date - mem.join_date ASC
			) AS food_order_rank
		FROM
			sales AS s
			INNER JOIN members AS mem ON s.customer_id = mem.customer_id
			AND s.order_date >= mem.join_date
			INNER JOIN menu AS m ON s.product_id = m.product_id
	)
SELECT
	customer_id,
	order_date,
	join_date,
	product_name
FROM
	order_after_membership
WHERE
	food_order_rank = 1
;

-- 7. Which item was purchased just before the customer became a member?
WITH
	order_after_membership AS (
		SELECT
			s.customer_id,
			s.order_date,
			mem.join_date,
			m.product_name,
			DENSE_RANK() OVER (
				PARTITION BY
					s.customer_id
				ORDER BY
					mem.join_date - s.order_date ASC
			) AS food_order_rank
		FROM
			sales AS s
			INNER JOIN members AS mem ON s.customer_id = mem.customer_id
			AND s.order_date < mem.join_date
			INNER JOIN menu AS m ON s.product_id = m.product_id
	)
SELECT
	customer_id,
	order_date,
	join_date,
	product_name
FROM
	order_after_membership
WHERE
	food_order_rank = 1
;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT
	s.customer_id,
	COUNT(*) AS total_ordered_items,
	SUM(m.price) AS total_amount_spent
FROM
	sales AS s
	INNER JOIN members AS mem ON s.customer_id = mem.customer_id
	AND s.order_date < mem.join_date
	INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY
	s.customer_id
;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - 
-- how many points would each customer have?
SELECT
	s.customer_id,
	SUM(
		CASE m.product_name
			WHEN 'sushi' THEN m.price * 20
			ELSE m.price * 10
		END
	) AS points
FROM
	sales AS s
	INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY
	s.customer_id
ORDER BY
	points DESC
;

-- 10. In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January?
SELECT
	s.customer_id,
	SUM(
		CASE
			WHEN s.order_date >= mem.join_date
			AND s.order_date <= mem.join_date + 7 THEN m.price * 20
			WHEN s.order_date > mem.join_date + 7
			OR s.order_date < mem.join_date
			AND m.product_name ILIKE 'sushi' THEN m.price * 20
			ELSE m.price * 10
		END
	) AS member_points
FROM
	sales AS s
	INNER JOIN menu AS m ON s.product_id = m.product_id
	INNER JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE
	s.order_date < '2021-02-01'
GROUP BY
	s.customer_id
;

-- 11. Danny also requires further information about the ranking of customer products, 
-- but he purposely does not need the ranking for non-member purchases so he expects 
-- null ranking values for the records when customers are not yet part of the loyalty program.
SELECT
	s.customer_id,
	s.order_date,
	m.product_name,
	m.price,
	CASE
		WHEN s.order_date >= mem.join_date THEN 'Y'
		ELSE 'N'
	END AS member,
	CASE
	-- When a order is placed after joining as a member
		WHEN s.order_date >= mem.join_date THEN DENSE_RANK() OVER (
			-- Ranking performed by partitioning customer and orders after membership
			PARTITION BY
				s.customer_id,
				s.order_date >= mem.join_date
			ORDER BY
				s.order_date ASC
		)
	END AS ranking
FROM
	sales AS s
	LEFT JOIN menu AS m ON s.product_id = m.product_id
	LEFT JOIN members AS mem ON s.customer_id = mem.customer_id
;