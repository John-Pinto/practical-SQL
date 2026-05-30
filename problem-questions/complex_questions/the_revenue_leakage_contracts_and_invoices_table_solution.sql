-- The Revenue Leakage
-- You work at a SaaS company that sells software licenses to enterprise clients. 
-- Each client has a contracted price agreed upon at the time of signing. 
-- However, the actual invoices raised each month sometimes differ from the contracted price — 
-- either due to discounts, billing errors, or unapproved price changes.
-- The finance team wants to identify revenue leakage — 
-- cases where clients are being billed less than their contracted price consistently over time.

-- The ask:
-- Find all contracts where the client was billed less than the contracted amount for 3 or more consecutive months. 

-- For each such contract return:
-- * contract_id
-- * client_id
-- * consecutive_months — the maximum streak of consecutive under-billed months
-- * total_leakage — total shortfall (sum of contracted_amount - invoice_amount) 
-- across the entire contract, not just the streak
-- * first_leakage_date — invoice date when the leakage streak first started
-- * last_leakage_date — invoice date when the longest streak ended

-- Constraints & Traps:
-- * A month within the contract window where no invoice was raised also 
-- counts as under-billing (leakage = full contracted_amount)
-- * A contract can have multiple leakage streaks — report only the longest one
-- * If two streaks are equally long, report the earliest one
-- * invoice_amount can never exceed contracted_amount in this dataset
-- * Contracts with zero leakage should not appear in the result

SET
	SEARCH_PATH = PROBLEM_QUESTIONS;

SELECT
	*
FROM
	contracts;

SELECT
	*
FROM
	invoices;

WITH
	generated_contract_period AS (
		SELECT
			contract_id,
			client_id,
			contracted_amount,
			GENERATE_SERIES(start_date, end_date, '1 month'::INTERVAL)::date AS contract_date
		FROM
			contracts
	),
	contract_invoice_leakage AS (
		SELECT
			c.contract_id,
			c.client_id,
			c.contract_date,
			c.contracted_amount - COALESCE(i.invoice_amount, 0) AS amt_diff,
			CASE
				WHEN c.contracted_amount = COALESCE(i.invoice_amount, 0) THEN 0
				ELSE 1
			END AS amt_leakage_flag
		FROM
			generated_contract_period AS c
			LEFT JOIN invoices AS i ON c.contract_id = i.contract_id AND
			c.contract_date = i.invoice_date
	),
	leakage_rankings AS (
		SELECT
			contract_id,
			client_id,
			contract_date,
			SUM(amt_diff) OVER (
				PARTITION BY
					contract_id
			) AS total_leakage,
			amt_leakage_flag,
			ROW_NUMBER() OVER (contract_window) AS pk_rank,
			ROW_NUMBER() OVER (contract_leakage_window) AS pk_flag_rank,
			ROW_NUMBER() OVER (contract_window) - ROW_NUMBER() OVER (contract_leakage_window) AS leakage_flag_grouping
		FROM
			contract_invoice_leakage
		WINDOW
			contract_window AS (
				PARTITION BY
					contract_id
				ORDER BY
					contract_date
			),
			contract_leakage_window AS (
				PARTITION BY
					contract_id,
					amt_leakage_flag
				ORDER BY
					contract_date
			)
	),
	leakage_filtering AS (
		SELECT
			contract_id,
			client_id,
			COUNT(leakage_flag_grouping) AS consecutive_months,
			total_leakage,
			MIN(contract_date) AS first_leakage_date,
			MAX(contract_date) AS last_leakage_date,
			ROW_NUMBER() OVER (
				PARTITION BY
					contract_id
				ORDER BY
					COUNT(leakage_flag_grouping) DESC,
					MIN(contract_date) ASC
			) AS longest_leakage
		FROM
			leakage_rankings
		WHERE
			amt_leakage_flag = 1
		GROUP BY
			contract_id,
			client_id,
			leakage_flag_grouping,
			total_leakage
		HAVING
			COUNT(leakage_flag_grouping) >= 3
	)
SELECT
	contract_id,
	client_id,
	consecutive_months,
	total_leakage,
	first_leakage_date,
	last_leakage_date
FROM
	leakage_filtering
WHERE
	longest_leakage = 1;