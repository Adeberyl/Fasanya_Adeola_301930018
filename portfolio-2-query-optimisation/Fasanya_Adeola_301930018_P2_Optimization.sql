-- Run this setup block once.
-- Create a separate schema for Portfolio 2.
CREATE SCHEMA p2_benchmark;

-- Create one synthetic booking-history table.
-- The primary-key index is created automatically by PostgreSQL.
CREATE TABLE p2_benchmark.booking_history_synthetic (
    history_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    driver_id BIGINT NOT NULL,
    event_at TIMESTAMPTZ NOT NULL,
    event_status VARCHAR(20) NOT NULL
);

-- Generate 100,000 synthetic records using existing identifiers.
-- Each of 1,000 dates receives 100 records.
WITH
customer_ids AS (
    SELECT array_agg(customer_id ORDER BY customer_id) AS ids
    FROM public.customer
),
booking_ids AS (
    SELECT array_agg(booking_id ORDER BY booking_id) AS ids
    FROM public.booking
),
driver_ids AS (
    SELECT array_agg(driver_id ORDER BY driver_id) AS ids
    FROM public.driver
)
INSERT INTO p2_benchmark.booking_history_synthetic
    (booking_id, customer_id, driver_id, event_at, event_status)
SELECT
    b.ids[((g - 1) % cardinality(b.ids)) + 1],
    c.ids[((g - 1) % cardinality(c.ids)) + 1],
    d.ids[((g - 1) % cardinality(d.ids)) + 1],
    TIMESTAMPTZ '2025-01-01 00:00:00+00'
        + (((g - 1) % 1000) * INTERVAL '1 day')
        + (((g - 1) / 1000)::INT * INTERVAL '1 minute'),
    CASE (g % 5)
        WHEN 0 THEN 'completed'
        WHEN 1 THEN 'requested'
        WHEN 2 THEN 'assigned'
        WHEN 3 THEN 'in progress'
        ELSE 'cancelled'
    END
FROM generate_series(1, 100000) AS series(g)
CROSS JOIN customer_ids AS c
CROSS JOIN booking_ids AS b
CROSS JOIN driver_ids AS d;

-- Refresh statistics and verify the total row count.
ANALYZE p2_benchmark.booking_history_synthetic;

SELECT COUNT(*) AS total_history_records
FROM p2_benchmark.booking_history_synthetic;

-- Run before creating the benchmark index.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    history_id,
    booking_id,
    customer_id,
    driver_id,
    event_at,
    event_status
FROM p2_benchmark.booking_history_synthetic
WHERE event_at >= TIMESTAMPTZ '2025-03-01 00:00:00+00'
  AND event_at <  TIMESTAMPTZ '2025-03-09 00:00:00+00'
ORDER BY event_at, history_id;

-- Create the index after collecting the pre-index results.
CREATE INDEX idx_booking_history_synthetic_event_at_history_id
ON p2_benchmark.booking_history_synthetic
USING BTREE (event_at, history_id);

-- Refresh planner statistics after creating the index.
ANALYZE p2_benchmark.booking_history_synthetic;

-- Run after creating the benchmark index.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    history_id,
    booking_id,
    customer_id,
    driver_id,
    event_at,
    event_status
FROM p2_benchmark.booking_history_synthetic
WHERE event_at >= TIMESTAMPTZ '2025-03-01 00:00:00+00'
  AND event_at <  TIMESTAMPTZ '2025-03-09 00:00:00+00'
ORDER BY event_at, history_id;