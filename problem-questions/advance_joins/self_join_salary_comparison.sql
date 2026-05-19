-- Using the emp table, find the employees that have more salary than their manager.

DROP TABLE IF EXISTS emp;

CREATE TABLE emp (
	emp_id INT,
	emp_name VARCHAR(10),
	salary INT,
	manager_id INT
);

INSERT INTO
	emp
VALUES
	(1, 'Ankit', 10000, 4),
	(2, 'Mohit', 15000, 5),
	(3, 'Vikas', 10000, 4),
	(4, 'Rohit', 5000, 2),
	(5, 'Mudit', 12000, 6),
	(6, 'Agam', 12000, 2),
	(7, 'Sanjay', 9000, 2),
	(8, 'Ashish', 5000, 2);

-- solution

SELECT
	*
FROM
	emp;

SELECT
	e.emp_id,
	e.emp_name,
	e.manager_id,
	m.emp_name AS manager_name,
	e.salary AS emp_salary,
	m.salary AS manager_salary
FROM
	emp AS e,
	emp AS m
WHERE
	m.emp_id = e.manager_id
	AND e.salary > m.salary
ORDER BY
	1;