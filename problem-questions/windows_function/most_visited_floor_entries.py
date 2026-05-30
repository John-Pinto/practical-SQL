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
    # Most Visited Floor

    Using the entries table, get the total_visit for person and the most_visited_floor by that person also get all the resources_used by that person in a single field.
    """)
    return


@app.cell
def _(mo):
    _df = mo.sql(
        f"""
        DROP TABLE IF EXISTS entries;

        CREATE TABLE entries (
        	name VARCHAR(20),
        	address VARCHAR(20),
        	email VARCHAR(20),
        	floor INT,
        	resources VARCHAR(10)
        );

        INSERT INTO
        	entries
        VALUES
        	('A', 'Bangalore', 'A@gmail.com', 1, 'CPU'),
        	('A', 'Bangalore', 'A1@gmail.com', 1, 'CPU'),
        	('A', 'Bangalore', 'A2@gmail.com', 2, 'DESKTOP'),
        	('B', 'Bangalore', 'B@gmail.com', 2, 'DESKTOP'),
        	('B', 'Bangalore', 'B1@gmail.com', 2, 'DESKTOP'),
        	('B', 'Bangalore', 'B2@gmail.com', 1, 'MONITOR');

        SELECT * FROM entries;
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
def _(entries, mo):
    _df = mo.sql(
        f"""
        WITH
        	total_visits AS (
        		SELECT
        			name,
        			COUNT(*) AS total_visit,
        			STRING_AGG(DISTINCT resources, ',') AS resources_used
        		FROM
        			entries
        		GROUP BY
        			name
        	),
        	floor_visits AS (
        		SELECT
        			name,
        			floor,
        			COUNT(*) AS no_of_floor_visit,
        			DENSE_RANK() OVER (
        				PARTITION BY
        					name
        				ORDER BY
        					COUNT(*) DESC
        			) AS visit_rank
        		FROM
        			entries
        		GROUP BY
        			name,
        			floor
        	)
        SELECT
        	name,
        	total_visit,
        	floor AS most_visited_floor,
        	resources_used
        FROM
        	floor_visits
        	INNER JOIN total_visits USING (name)
        WHERE
        	visit_rank = 1;
        """
    )
    return


if __name__ == "__main__":
    app.run()
