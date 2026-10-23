
BEGIN;

-- Move an assigned booking to in progress, only once.
UPDATE public.booking
SET status = 'in progress'
WHERE booking_id = YOUR_BOOKING_ID
  AND status = 'assigned';

COMMIT;

BEGIN
UPDATE 1
COMMIT


UPDATE public.booking
SET status = 'in progress'
WHERE booking_id = YOUR_BOOKING_ID
  AND status = 'assigned';


BEGIN;

-- Make a valid change inside the transaction.
UPDATE public.booking
SET status = 'cancelled'
WHERE booking_id = YOUR_OTHER_BOOKING_ID
  AND status IN ('requested', 'assigned');

-- Deliberately violate chk_booking_status.
UPDATE public.booking
SET status = 'invalid status'
WHERE booking_id = YOUR_OTHER_BOOKING_ID;

-- Run this after the constraint error.
ROLLBACK;


SELECT booking_id, status
FROM public.booking
WHERE booking_id = YOUR_BOOKING_ID;
