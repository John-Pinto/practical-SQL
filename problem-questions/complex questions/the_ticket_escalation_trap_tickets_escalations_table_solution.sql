-- The Ticket Escalation Trap

-- You work at a SaaS customer support company. 
-- Support tickets are raised by customers and assigned to agents. 
-- Tickets can be escalated from one agent to another when the current agent cannot resolve them. 
-- Each escalation is logged with a timestamp.
-- The support manager wants to identify tickets that are stuck in an "Escalation Trap" — 
-- tickets that have been escalated 3 or more times and are still unresolved, 
-- along with insights about which agents are escalating the most and how long tickets are spending at each level.

-- The Ask:
-- Find all tickets in an Escalation Trap and return one row per ticket containing:
-- * ticket_id
-- * customer_id
-- * priority
-- * escalation_count — total number of escalations for this ticket
-- * total_hours_open — hours since ticket was created until now (use 2024-06-01 00:00:00 as current time)
-- * avg_hours_per_escalation — average hours spent at each escalation level
-- * most_frequent_escalator — from_agent_id who escalated this ticket the most. If two or more agents escalated equally many times, pick the one with the lowest agent_id
-- * current_agent_id — the to_agent_id of the most recent escalation (currently holding the ticket)

-- Constraints & Traps:
-- * Only include tickets with status = 'open'
-- * Only include tickets escalated 3 or more times
-- * If two agents escalated equally, pick the one with the lower agent ID
-- * avg_hours_per_escalation = total_hours_open / escalation_count, rounded to 2 decimal places
-- * A ticket can be escalated to the same agent multiple times

SELECT
	*
FROM
	tickets;

SELECT
	*
FROM
	escalations;

WITH
	open_tickets_calc AS (
		SELECT
			ticket_id,
			customer_id,
			priority,
			created_at,
			'2024-06-01'::TIMESTAMP AS current_datetime,
			ROUND(
				EXTRACT(
					epoch
					FROM
						('2024-06-01'::TIMESTAMP - created_at)
				) / 3600,
				2
			) AS total_hours_open
		FROM
			tickets
		WHERE
			status = 'open'
	),
	ticket_escalation_base AS (
		SELECT
			t.ticket_id,
			t.customer_id,
			t.priority,
			COUNT(*) AS escalation_count,
			t.total_hours_open,
			ROUND(t.total_hours_open / COUNT(*), 2) AS avg_hours_per_escalation
		FROM
			open_tickets_calc AS t
			JOIN escalations AS e ON t.ticket_id = e.ticket_id
		GROUP BY
			t.ticket_id,
			t.customer_id,
			t.priority,
			t.total_hours_open
		HAVING
			COUNT(*) > 2
	),
	frequency_escalator AS (
		SELECT
			ticket_id,
			from_agent_id,
			ROW_NUMBER() OVER (
				PARTITION BY
					ticket_id
				ORDER BY
					COUNT(*) DESC,
					from_agent_id ASC
			) AS freq_rank
		FROM
			escalations
		GROUP BY
			ticket_id,
			from_agent_id
	),
	current_agent AS (
		SELECT
			ticket_id,
			to_agent_id,
			ROW_NUMBER() OVER (
				PARTITION BY
					ticket_id
				ORDER BY
					escalated_at DESC
			) AS agent_index
		FROM
			escalations
	)
SELECT
	b.ticket_id,
	b.customer_id,
	b.priority,
	b.escalation_count,
	b.total_hours_open,
	b.avg_hours_per_escalation,
	fe.from_agent_id AS most_frequent_escalator,
	ca.to_agent_id AS current_agent_id
FROM
	ticket_escalation_base AS b
	JOIN frequency_escalator AS fe ON b.ticket_id = fe.ticket_id AND
	freq_rank = 1
	JOIN current_agent AS ca ON b.ticket_id = ca.ticket_id AND
	agent_index = 1;