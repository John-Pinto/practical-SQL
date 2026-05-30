SET
	SEARCH_PATH = PROBLEM_QUESTIONS;

DROP TABLE IF EXISTS sales;

DROP TABLE IF EXISTS promotions;

CREATE TABLE sales (
	sale_id INT PRIMARY KEY,
	product_id INT NOT NULL,
	category VARCHAR NOT NULL,
	store_id INT NOT NULL,
	sale_date date NOT NULL,
	quantity INT NOT NULL,
	unit_price DECIMAL NOT NULL
);

CREATE TABLE promotions (
	promotion_id INT PRIMARY KEY,
	product_id INT NOT NULL,
	store_id INT NOT NULL,
	promo_start date NOT NULL,
	promo_end date NOT NULL
);

INSERT INTO
	sales (
		sale_id,
		product_id,
		category,
		store_id,
		sale_date,
		quantity,
		unit_price
	)
VALUES
	(
		1,
		101,
		'Electronics',
		1,
		'2024-01-15',
		10,
		500.00
	),
	(2, 101, 'Electronics', 2, '2024-02-20', 8, 500.00),
	(
		3,
		101,
		'Electronics',
		3,
		'2024-03-10',
		12,
		500.00
	),
	(
		4,
		102,
		'Electronics',
		1,
		'2024-01-10',
		15,
		450.00
	),
	(
		5,
		102,
		'Electronics',
		2,
		'2024-02-15',
		10,
		450.00
	),
	(6, 102, 'Electronics', 3, '2024-03-20', 8, 450.00),
	(
		7,
		107,
		'Electronics',
		1,
		'2024-01-12',
		20,
		490.00
	),
	(8, 103, 'Electronics', 1, '2024-01-05', 6, 480.00),
	(9, 103, 'Electronics', 2, '2024-02-10', 9, 480.00),
	(
		10,
		104,
		'Electronics',
		1,
		'2024-01-20',
		5,
		460.00
	),
	(
		11,
		104,
		'Electronics',
		2,
		'2024-02-25',
		4,
		460.00
	),
	(
		12,
		105,
		'Electronics',
		2,
		'2024-01-25',
		4,
		460.00
	),
	(
		13,
		105,
		'Electronics',
		3,
		'2024-03-15',
		5,
		460.00
	),
	(
		14,
		106,
		'Electronics',
		1,
		'2024-01-30',
		2,
		300.00
	),
	(
		15,
		106,
		'Electronics',
		2,
		'2024-02-28',
		3,
		300.00
	),
	(16, 201, 'Clothing', 1, '2024-01-08', 20, 150.00),
	(17, 201, 'Clothing', 2, '2024-02-12', 25, 150.00),
	(18, 201, 'Clothing', 3, '2024-03-18', 30, 150.00),
	(19, 202, 'Clothing', 1, '2024-01-15', 18, 140.00),
	(20, 202, 'Clothing', 2, '2024-02-20', 22, 140.00),
	(21, 202, 'Clothing', 3, '2024-03-25', 15, 140.00),
	(22, 203, 'Clothing', 1, '2024-01-20', 15, 130.00),
	(23, 203, 'Clothing', 2, '2024-02-25', 18, 130.00),
	(24, 206, 'Clothing', 1, '2024-01-22', 15, 115.00),
	(25, 206, 'Clothing', 3, '2024-02-18', 20, 115.00),
	(26, 204, 'Clothing', 1, '2024-02-01', 10, 120.00),
	(27, 204, 'Clothing', 3, '2024-03-05', 8, 120.00),
	(28, 205, 'Clothing', 2, '2024-01-10', 5, 100.00),
	(29, 301, 'Furniture', 1, '2024-01-03', 4, 800.00),
	(30, 301, 'Furniture', 2, '2024-02-08', 3, 800.00),
	(31, 302, 'Furniture', 2, '2024-01-18', 3, 750.00),
	(32, 302, 'Furniture', 3, '2024-02-22', 2, 750.00),
	(33, 303, 'Furniture', 1, '2024-01-25', 2, 700.00),
	(34, 303, 'Furniture', 3, '2024-03-01', 3, 700.00),
	(35, 305, 'Furniture', 3, '2024-01-28', 5, 720.00),
	(36, 306, 'Furniture', 1, '2024-01-30', 2, 680.00),
	(37, 306, 'Furniture', 3, '2024-02-25', 2, 680.00),
	(38, 304, 'Furniture', 1, '2024-02-10', 2, 650.00),
	(39, 304, 'Furniture', 2, '2024-03-15', 1, 650.00);

INSERT INTO
	promotions (
		promotion_id,
		product_id,
		store_id,
		promo_start,
		promo_end
	)
VALUES
	(1, 102, 1, '2024-01-01', '2024-01-31'),
	(2, 202, 3, '2024-03-01', '2024-03-31'),
	(3, 303, 2, '2024-01-15', '2024-02-15');