--In Session A, run this block first. Do not commit yet.
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Create a trip for existing booking 4 and driver 3.
INSERT INTO public.trip
    (booking_id, driver_id, started_at, completed_at, fare)
VALUES
    (4, 3, TIMESTAMPTZ '2026-10-23 13:00:00+00', NULL, NULL);


COMMIT;
--Explanation: Session A commits its trip, making the unique booking_id = 4 value permanent.
--STOP — switch back to Session B.
