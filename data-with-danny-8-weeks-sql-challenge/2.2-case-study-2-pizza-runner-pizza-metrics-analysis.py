import marimo

__generated_with = "0.23.8"
app = marimo.App(width="medium", auto_download=["ipynb", "html"])


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    # Pizza Runner Analysis - Pizza Metrics
    """)
    return


@app.cell
def _():
    import marimo as mo
    import duckdb

    conn = duckdb.connect(database='./data-with-danny-8-weeks-sql-challenge/2.1-case-study-2-pizza-runner-setup.duckdb')
    return (mo,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 1. How many pizzas were ordered?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 2. How many unique customer orders were made?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 3. How many successful orders were delivered by each runner?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 4. How many of each type of pizza was delivered?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 5. How many Vegetarian and Meatlovers were ordered by each customer?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 6. What was the maximum number of pizzas delivered in a single order?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 8. How many pizzas were delivered that had both exclusions and extras?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 9. What was the total volume of pizzas ordered for each hour of the day?
    """)
    return


@app.cell
def _():
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## 10. What was the volume of orders for each day of the week?
    """)
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
