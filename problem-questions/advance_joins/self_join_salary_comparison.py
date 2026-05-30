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
    # Self Join - Salary Comparison

    Using the emp table, find the employees that have more salary than their manager.
    """)
    return


@app.cell
def _(mo):
    _df = mo.sql(
        f"""
        DROP TABLE IF EXISTS EMP;

        CREATE TABLE EMP (
        	EMP_ID INT,
        	EMP_NAME VARCHAR(10),
        	SALARY INT,
        	MANAGER_ID INT
        );

        INSERT INTO
        	EMP
        VALUES
        	(1, 'Ankit', 10000, 4),
        	(2, 'Mohit', 15000, 5),
        	(3, 'Vikas', 10000, 4),
        	(4, 'Rohit', 5000, 2),
        	(5, 'Mudit', 12000, 6),
        	(6, 'Agam', 12000, 2),
        	(7, 'Sanjay', 9000, 2),
        	(8, 'Ashish', 5000, 2);

        SELECT * FROM EMP;
        """
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Solution:
    """)
    return


@app.cell
def _(emp, mo):
    _df = mo.sql(
        f"""
        SELECT
        	E.EMP_ID,
        	E.EMP_NAME,
        	E.MANAGER_ID,
        	M.EMP_NAME AS MANAGER_NAME,
        	E.SALARY AS EMP_SALARY,
        	M.SALARY AS MANAGER_SALARY
        FROM
        	EMP AS E,
        	EMP AS M
        WHERE
        	M.EMP_ID = E.MANAGER_ID
        	AND E.SALARY > M.SALARY
        ORDER BY
        	1;
        """
    )
    return


if __name__ == "__main__":
    app.run()
