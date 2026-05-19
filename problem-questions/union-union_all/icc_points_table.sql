-- Using the icc_world_cup, get the resulted table providing stats with matches_played, 
-- no_of_wins and no_of_losses for every team

DROP TABLE IF EXISTS icc_world_cup;

CREATE TABLE icc_world_cup (
	team_1 VARCHAR(20),
	team_2 VARCHAR(20),
	winner VARCHAR(20)
);

INSERT INTO
	icc_world_cup
VALUES
	('India', 'SL', 'India'),
	('SL', 'Aus', 'Aus'),
	('SA', 'Eng', 'Eng'),
	('Eng', 'NZ', 'NZ'),
	('Aus', 'India', 'India');
	
-- solution

SELECT
	*
FROM
	icc_world_cup;

-- Best way
WITH
	winner_teams AS (
		SELECT
			team_1 AS team_name,
			CASE
				WHEN team_1 = winner THEN 1
				ELSE 0
			END AS win_flag
		FROM
			icc_world_cup
		UNION ALL
		SELECT
			team_2 AS team_name,
			CASE
				WHEN team_2 = winner THEN 1
				ELSE 0
			END AS win_flag
		FROM
			icc_world_cup
	)
SELECT
	team_name,
	COUNT(*) AS matches_played,
	SUM(win_flag) AS no_of_wins,
	COUNT(*) - SUM(win_flag) AS no_of_losses
FROM
	winner_teams
GROUP BY
	team_name;

-- Hard way
WITH
	team_1_count AS (
		SELECT
			team_1 AS team_name,
			COUNT(team_1)
		FROM
			icc_world_cup
		GROUP BY
			team_1
	),
	team_2_count AS (
		SELECT
			team_2 AS team_name,
			COUNT(team_2)
		FROM
			icc_world_cup
		GROUP BY
			team_2
	),
	winners_count AS (
		SELECT
			winner AS team_name,
			COUNT(winner)
		FROM
			icc_world_cup
		GROUP BY
			winner
	),
	combine_teams AS (
		SELECT
			team_name,
			count,
			'played' AS match_tag
		FROM
			team_1_count
		UNION ALL
		SELECT
			team_name,
			count,
			'played' AS match_tag
		FROM
			team_2_count
	),
	total_matches AS (
		SELECT
			team_name,
			SUM(count) AS matches_played
		FROM
			combine_teams
		GROUP BY
			team_name
	)
SELECT
	tm.team_name,
	tm.matches_played,
	COALESCE(wc.count, 0) AS no_of_wins,
	tm.matches_played - COALESCE(wc.count, 0) AS no_of_losses
FROM
	total_matches AS tm
	LEFT JOIN winners_count AS wc ON tm.team_name = wc.team_name;