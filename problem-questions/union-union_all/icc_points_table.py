import marimo

__generated_with = "0.23.8"
app = marimo.App(width="medium", auto_download=["html", "ipynb"])


@app.cell
def _():
    import marimo as mo

    return (mo,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    # ICC Statistics

    Using the icc_world_cup, get the resulted table providing stats with matches_played, no_of_wins and no_of_losses for every team.
    """)
    return


@app.cell
def _(mo):
    _df = mo.sql(
        f"""
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

        SELECT * FROM icc_world_cup;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    # Solution
    """)
    return


@app.cell
def _(icc_world_cup, mo):
    _df = mo.sql(
        f"""
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
        """
    )
    return


if __name__ == "__main__":
    app.run()
