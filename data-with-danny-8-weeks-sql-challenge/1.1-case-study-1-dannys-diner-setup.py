import marimo

__generated_with = "0.23.8"
app = marimo.App(width="medium", auto_download=["ipynb", "html"])


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    # [8 Weeks SQL Challenge - Case Study 1 : Danny's Diner](https://8weeksqlchallenge.com/case-study-1/)

    ## Data Setup
    """)
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    **Table 1: sales**

    The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
    """)
    return


@app.cell
def _():
    import marimo as mo

    return (mo,)


@app.cell
def _():
    import duckdb

    return


@app.cell
def _(mo):
    _df = mo.sql(
        f"""
        DROP TABLE IF EXISTS SALES;

        CREATE TABLE SALES (
        	"customer_id" VARCHAR(1),
        	"order_date" DATE,
        	"product_id" INTEGER
        );

        INSERT INTO
        	SALES ("customer_id", "order_date", "product_id")
        VALUES
        	('A', '2021-01-01', '1'),
        	('A', '2021-01-01', '2'),
        	('A', '2021-01-07', '2'),
        	('A', '2021-01-10', '3'),
        	('A', '2021-01-11', '3'),
        	('A', '2021-01-11', '3'),
        	('B', '2021-01-01', '2'),
        	('B', '2021-01-02', '2'),
        	('B', '2021-01-04', '1'),
        	('B', '2021-01-11', '1'),
        	('B', '2021-01-16', '3'),
        	('B', '2021-02-01', '3'),
        	('C', '2021-01-01', '3'),
        	('C', '2021-01-01', '3'),
        	('C', '2021-01-07', '3');

        SELECT * FROM SALES;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    **Table 2: menu**

    The menu table maps the product_id to the actual product_name and price of each menu item.
    """)
    return


@app.cell
def _(mo):
    _df = mo.sql(
        f"""
        DROP TABLE IF EXISTS MENU;

        CREATE TABLE MENU (
        	"product_id" INTEGER,
        	"product_name" VARCHAR(5),
        	"price" INTEGER
        );

        INSERT INTO
        	MENU ("product_id", "product_name", "price")
        VALUES
        	('1', 'sushi', '10'),
        	('2', 'curry', '15'),
        	('3', 'ramen', '12');

        SELECT * FROM MENU;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    **Table 3: members**

    The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.
    """)
    return


@app.cell
def _(mo):
    _df = mo.sql(
        f"""
        DROP TABLE IF EXISTS MEMBERS;

        CREATE TABLE MEMBERS ("customer_id" VARCHAR(1), "join_date" DATE);

        INSERT INTO
        	MEMBERS ("customer_id", "join_date")
        VALUES
        	('A', '2021-01-07'),
        	('B', '2021-01-09');

        SELECT * FROM members;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 1. What is the total amount each customer spent at the restaurant?
    """)
    return


@app.cell
def _(menu, mo, sales):
    _df = mo.sql(
        f"""
        SELECT
        	s.customer_id,
        	SUM(m.price) AS total_amount
        FROM
        	sales AS s
        	INNER JOIN menu AS m ON s.product_id = m.product_id
        GROUP BY
        	s.customer_id
        ORDER BY
        	total_amount DESC;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 2. How many days has each customer visited the restaurant?
    """)
    return


@app.cell
def _(mo, sales):
    _df = mo.sql(
        f"""
        SELECT
        	customer_id,
        	COUNT(DISTINCT order_date) AS visited_days
        FROM
        	sales
        GROUP BY
        	customer_id
        ORDER BY
        	visited_days DESC;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 3. What was the first item from the menu purchased by each customer?
    """)
    return


@app.cell
def _(menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	order_rank = 1;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
    """)
    return


@app.cell
def _(menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	1;
        """
    )
    return


@app.cell
def _(menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	m.product_name;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 5. Which item was the most popular for each customer?
    """)
    return


@app.cell
def _(menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	popularity_rank = 1;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 6. Which item was purchased first by the customer after they became a member?
    """)
    return


@app.cell
def _(members, menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	food_order_rank = 1;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 7. Which item was purchased just before the customer became a member?
    """)
    return


@app.cell
def _(members, menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	food_order_rank = 1;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 8. What is the total items and amount spent for each member before they became a member?
    """)
    return


@app.cell
def _(members, menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	s.customer_id;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
    """)
    return


@app.cell
def _(menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	points DESC;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
    """)
    return


@app.cell
def _(members, menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	s.customer_id;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 11. Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
    """)
    return


@app.cell
def _(members, menu, mo, sales):
    _df = mo.sql(
        f"""
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
        	LEFT JOIN members AS mem ON s.customer_id = mem.customer_id;
        """
    )
    return


if __name__ == "__main__":
    app.run()
