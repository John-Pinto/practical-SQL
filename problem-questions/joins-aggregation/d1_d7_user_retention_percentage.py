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
    # [User Retention on Day 1 and Day 7](https://www.thequerylab.com/problems/121-d1-d7-retention)

    Analyze user stickiness for the January 2024 cohort.
    Calculate the percentage of users who were active on Day 1 and Day 7 post-signup.

    Rules:
    * Output columns: day_1_retention, day_7_retention.
    * Formula: (Users back on Day X / Total Users in Cohort) * 100.
    * Cohort: Users with signup_date in January 2024.
    * Round to 2 decimal places.
    """)
    return


@app.cell
def _(mo):
    _df = mo.sql(
        f"""
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
        """
    )
    return


@app.cell
def _(mo, users):
    _df = mo.sql(
        f"""
        SELECT * FROM users;
        """
    )
    return


@app.cell
def _(mo, user_activity):
    _df = mo.sql(
        f"""
        SELECT * FROM user_activity;
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
def _(mo, user_activity, users):
    _df = mo.sql(
        f"""
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
        """
    )
    return


if __name__ == "__main__":
    app.run()
