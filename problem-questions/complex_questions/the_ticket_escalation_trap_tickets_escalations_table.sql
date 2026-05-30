SET
	SEARCH_PATH = PROBLEM_QUESTIONS;

DROP TABLE IF EXISTS escalations;

DROP TABLE IF EXISTS tickets;

-- DDL for tickets
CREATE TABLE tickets (
	ticket_id INT PRIMARY KEY,
	customer_id INT,
	created_at TIMESTAMP,
	status VARCHAR(20),
	priority VARCHAR(20)
);

-- DML for tickets
INSERT INTO
	tickets (
		ticket_id,
		customer_id,
		created_at,
		status,
		priority
	)
VALUES
	(1, 101, '2024-05-01 08:00:00', 'open', 'high'),
	(2, 102, '2024-05-10 10:00:00', 'open', 'medium'),
	(3, 103, '2024-04-15 09:00:00', 'open', 'critical'),
	(4, 104, '2024-05-05 11:00:00', 'closed', 'high'),
	(5, 105, '2024-05-20 14:00:00', 'open', 'low'),
	(6, 106, '2024-05-15 08:00:00', 'open', 'high'),
	(7, 107, '2024-05-25 10:00:00', 'open', 'medium'),
	(8, 108, '2024-05-08 07:00:00', 'open', 'critical');

-- DDL for escalations
CREATE TABLE escalations (
	escalation_id INT PRIMARY KEY,
	ticket_id INT REFERENCES tickets (ticket_id),
	from_agent_id INT,
	to_agent_id INT,
	escalated_at TIMESTAMP
);

-- DML for escalations
INSERT INTO
	escalations (
		escalation_id,
		ticket_id,
		from_agent_id,
		to_agent_id,
		escalated_at
	)
VALUES
	(1, 1, 201, 202, '2024-05-02 09:00:00'),
	(2, 1, 202, 203, '2024-05-05 10:00:00'),
	(3, 1, 201, 204, '2024-05-10 11:00:00'),
	(4, 1, 204, 205, '2024-05-20 14:00:00'),
	(5, 2, 301, 302, '2024-05-11 09:00:00'),
	(6, 2, 302, 303, '2024-05-15 10:00:00'),
	(7, 2, 303, 304, '2024-05-20 11:00:00'),
	(8, 3, 401, 402, '2024-04-16 08:00:00'),
	(9, 3, 402, 403, '2024-04-20 09:00:00'),
	(10, 3, 401, 404, '2024-04-25 10:00:00'),
	(11, 3, 404, 405, '2024-05-01 11:00:00'),
	(12, 3, 401, 406, '2024-05-10 12:00:00'),
	(13, 4, 501, 502, '2024-05-06 09:00:00'),
	(14, 4, 502, 503, '2024-05-10 10:00:00'),
	(15, 4, 503, 504, '2024-05-15 11:00:00'),
	(16, 4, 504, 505, '2024-05-20 12:00:00'),
	(17, 5, 601, 602, '2024-05-21 09:00:00'),
	(18, 5, 602, 603, '2024-05-25 10:00:00'),
	(19, 6, 701, 702, '2024-05-16 09:00:00'),
	(20, 6, 702, 703, '2024-05-20 10:00:00'),
	(21, 6, 703, 704, '2024-05-25 11:00:00'),
	(22, 8, 801, 802, '2024-05-09 08:00:00'),
	(23, 8, 802, 803, '2024-05-12 09:00:00'),
	(24, 8, 803, 802, '2024-05-18 10:00:00'),
	(25, 8, 802, 804, '2024-05-25 11:00:00');