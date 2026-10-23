
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

INSERT INTO public.trip
    (booking_id, driver_id, started_at, completed_at, fare)
VALUES
    (4, 3, TIMESTAMPTZ '2026-10-23 13:00:00+00', NULL, NULL);
--Expected result (prediction): Session B reaches the INSERT and waits instead of immediately succeeding or returning a unique-constraint error.
--Explanation: PostgreSQL checks the existing unique index entry for booking_id; it must wait for Session A's transaction to resolve the possible conflict

--Once Session A commits, Session B's waiting insert should finish with a unique-constraint error.
ERROR: duplicate key value violates unique constraint
       "trip_booking_id_key"
DETAIL: Key (booking_id)=(4) already exists.
--The exact constraint name in the error is expected to be PostgreSQL's generated name for the unique constraint, trip_booking_id_key.

ROLLBACK;
--Explanation: PostgreSQL rejects Session B's duplicate trip, and ROLLBACK ends the failed transaction cleanly. It does not undo Session A's committed trip.