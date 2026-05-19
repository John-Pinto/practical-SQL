-- https://www.thequerylab.com/problems/121-d1-d7-retention
-- Analyze user stickiness for the January 2024 cohort. C
-- Calculate the percentage of users who were active on Day 1 and Day 7 post-signup.
-- Rules:
-- Output columns: day_1_retention, day_7_retention.
-- Formula: (Users back on Day X / Total Users in Cohort) * 100.
-- Cohort: Users with signup_date in January 2024.
-- Round to 2 decimal places.

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS user_activity;

CREATE TABLE users (user_id INTEGER, signup_date date);

CREATE TABLE user_activity (user_id INTEGER, activity_date date);

INSERT INTO
	users (user_id, signup_date)
VALUES
	(1, '2024-01-01'),
	(2, '2024-01-01'),
	(3, '2024-02-01');

INSERT INTO
	user_activity (user_id, activity_date)
VALUES
	(1, '2024-01-02'),
	(1, '2024-01-08'),
	(2, '2024-01-02');

-- solution

SELECT
	ROUND(
		COUNT(
			DISTINCT CASE
				WHEN u.signup_date + 1 = ua.activity_date THEN u.user_id
			END
		) * 100.0 / COUNT(DISTINCT u.user_id),
		2
	) AS day_1_retention,
	ROUND(
		COUNT(
			DISTINCT CASE
				WHEN u.signup_date + 7 = ua.activity_date THEN u.user_id
			END
		) * 100.0 / COUNT(DISTINCT u.user_id),
		2
	) AS day_7_retention
FROM
	users AS u
	LEFT JOIN user_activity AS ua ON u.user_id = ua.user_id
WHERE
	u.signup_date >= '2024-01-01' AND
	u.signup_date <= '2024-01-31'