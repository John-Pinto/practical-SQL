SET
	SEARCH_PATH = DANNYS_DINER;

DROP TABLE IF EXISTS MEMBERS;

DROP TABLE IF EXISTS MENU;

DROP TABLE IF EXISTS SALES;

DROP SCHEMA IF EXISTS DANNYS_DINER;

CREATE SCHEMA DANNYS_DINER;

-- Table 1: sales
-- The sales table captures all customer_id level purchases with an corresponding 
-- order_date and product_id information for when and what menu items were ordered.

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

-- Table 2: menu
-- The menu table maps the product_id to the actual product_name and price of each menu item.

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
	
-- Table 3: members
-- The final members table captures the join_date when a customer_id joined 
-- the beta version of the Danny’s Diner loyalty program.

CREATE TABLE MEMBERS ("customer_id" VARCHAR(1), "join_date" DATE);

INSERT INTO
	MEMBERS ("customer_id", "join_date")
VALUES
	('A', '2021-01-07'),
	('B', '2021-01-09');