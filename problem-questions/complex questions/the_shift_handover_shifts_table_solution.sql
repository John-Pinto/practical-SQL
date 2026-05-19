-- The Shift Handover Problem

-- You work at a 24/7 logistics company that operates in shifts. 
-- Each shift has an opening stock count and a closing stock count for a warehouse. 
-- The closing stock of one shift should match the opening stock of the next shift. 
-- When they don't match, it indicates a handover discrepancy — 
-- stock went missing or was incorrectly recorded during the shift change. 
-- The operations team wants to identify all discrepancies, understand their impact, 
-- and flag the worst handover per warehouse.

-- The Ask
-- Find all handover discrepancies and return one row per discrepancy:
-- * warehouse_id
-- * outgoing_shift_id — the shift that closed
-- * incoming_shift_id — the shift that opened next
-- * closing_stock — closing stock of outgoing shift
-- * opening_stock — opening stock of incoming shift
-- * discrepancy — difference (opening_stock - closing_stock), negative means stock missing
-- * gap_minutes — minutes between shift_end and next shift_start
-- * discrepancy_type — 'shortage' if discrepancy < 0, 'surplus' if discrepancy > 0
-- * is_worst_handover — 'Y' if this is the largest absolute discrepancy in the warehouse, 'N' otherwise

-- Constraints & Traps:
-- * Only compare shifts consecutive within the same warehouse
-- * Skip terminal shifts (no next shift)
-- * Skip clean handovers (closing_stock = opening_stock)
-- * gap_minutes can be 0 or positive

SELECT
	*
FROM
	shifts;

WITH
	adding_next_shift_data AS (
		SELECT
			shift_id,
			warehouse_id,
			shift_start,
			shift_end,
			opening_stock,
			closing_stock,
			LEAD(shift_id) OVER (
				PARTITION BY
					warehouse_id
				ORDER BY
					shift_start
			) AS next_shift_id,
			LEAD(shift_start) OVER (
				PARTITION BY
					warehouse_id
				ORDER BY
					shift_start
			) AS next_shift_start,
			LEAD(opening_stock) OVER (
				PARTITION BY
					warehouse_id
				ORDER BY
					shift_start
			) AS next_opening_stock
		FROM
			shifts
	),
	handover_discrepancy_calc AS (
		SELECT
			warehouse_id,
			shift_id AS outgoing_shift_id,
			next_shift_id AS incoming_shift_id,
			closing_stock,
			next_opening_stock AS opening_stock,
			next_opening_stock - closing_stock AS discrepancy,
			(
				EXTRACT(
					epoch
					FROM
						(next_shift_start - shift_end)
				) / 60
			)::INT AS gap_minutes,
			CASE
				WHEN next_opening_stock - closing_stock < 0 THEN 'shortage'
				ELSE 'surplus'
			END AS discrepancy_type,
			DENSE_RANK() OVER (
				PARTITION BY
					warehouse_id
				ORDER BY
					ABS(next_opening_stock - closing_stock) DESC
			) AS discrepancy_rank
		FROM
			adding_next_shift_data
		WHERE
			next_shift_id IS NOT NULL AND
			closing_stock != next_opening_stock
	)
SELECT
	warehouse_id,
	outgoing_shift_id,
	incoming_shift_id,
	closing_stock,
	opening_stock,
	discrepancy,
	gap_minutes,
	discrepancy_type,
	CASE
		WHEN discrepancy_rank = 1 THEN 'Y'
		ELSE 'N'
	END AS is_worst_handover
FROM
	handover_discrepancy_calc
ORDER BY
	1 ASC,
	2 ASC;