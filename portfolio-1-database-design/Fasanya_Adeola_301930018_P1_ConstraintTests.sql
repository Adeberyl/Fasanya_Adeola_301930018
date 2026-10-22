
-- ConstraintTests.sql
-- Run each INSERT separately.
-- Every test is expected to fail without adding a row.

-- TEST 1: Required customer name.
-- Expected error: NOT NULL violation on full_name.
INSERT INTO public.customer (full_name, email)
VALUES (NULL, 'required-customer@example.com');

-- TEST 2: Required driver availability.
-- Expected error: NOT NULL violation on is_available.
INSERT INTO public.driver (full_name, licence_number, is_available)
VALUES ('Test Driver', 'LIC-TEST-201', NULL);

-- TEST 3: Required vehicle registration.
-- Expected error: NOT NULL violation on registration_number.
INSERT INTO public.vehicle (registration_number, driver_id)
VALUES (NULL, (
    SELECT driver_id FROM public.driver
    WHERE licence_number = 'LIC-102'
));

-- TEST 4: Required booking destination.
-- Expected error: NOT NULL violation on destination.
INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'passenger ride', 'Test Pickup', NULL,
       CURRENT_TIMESTAMP, 'requested'
FROM public.customer
WHERE email = 'ada@example.com';

-- TEST 5: Required trip driver.
-- Expected error: NOT NULL violation on driver_id.
-- Booking 104 is the requested booking without a trip.
INSERT INTO public.trip (booking_id, driver_id)
SELECT b.booking_id, NULL
FROM public.booking b
JOIN public.customer c ON c.customer_id = b.customer_id
WHERE c.email = 'ben@example.com'
  AND b.pickup_location = 'Surulere';

-- TEST 6: Unique customer email.
-- Expected error: duplicate key violates customer email uniqueness.
INSERT INTO public.customer (full_name, email)
VALUES ('Another Customer', 'ada@example.com');

-- TEST 7: Unique driver licence number.
-- Expected error: duplicate key violates licence_number uniqueness.
INSERT INTO public.driver (full_name, licence_number, is_available)
VALUES ('Another Driver', 'LIC-100', TRUE);

-- TEST 8: Unique vehicle registration.
-- Expected error: duplicate key violates registration_number uniqueness.
-- The new driver avoids a conflict on vehicle.driver_id.
WITH new_driver AS (
    INSERT INTO public.driver (full_name, licence_number, is_available)
    VALUES ('Temporary Test Driver', 'LIC-TEST-202', TRUE)
    RETURNING driver_id
)
INSERT INTO public.vehicle (registration_number, driver_id)
SELECT 'LAG-123-AB', driver_id FROM new_driver;

-- TEST 9: One vehicle per driver.
-- Expected error: duplicate key violates vehicle.driver_id uniqueness.
INSERT INTO public.vehicle (registration_number, driver_id)
SELECT 'TEST-UNIQUE-VEHICLE',
       driver_id
FROM public.driver
WHERE licence_number = 'LIC-102';

-- TEST 10: Booking must reference an existing customer.
-- Expected error: foreign key violation on customer_id.
INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
VALUES
    (-999999, 'passenger ride', 'Test Pickup', 'Test Destination',
     CURRENT_TIMESTAMP, 'requested');

-- TEST 11: Vehicle must reference an existing driver.
-- Expected error: foreign key violation on driver_id.
INSERT INTO public.vehicle (registration_number, driver_id)
VALUES ('TEST-FK-VEHICLE', -999999);

-- TEST 12: Trip must reference an existing booking.
-- Expected error: foreign key violation on booking_id.
INSERT INTO public.trip (booking_id, driver_id)
SELECT -999999, driver_id
FROM public.driver
WHERE licence_number = 'LIC-102';

-- TEST 13: Trip must reference an existing driver.
-- Expected error: foreign key violation on driver_id.
-- Booking 104 has no trip, so booking uniqueness does not conflict.
INSERT INTO public.trip (booking_id, driver_id)
SELECT b.booking_id, -999999
FROM public.booking b
JOIN public.customer c ON c.customer_id = b.customer_id
WHERE c.email = 'ben@example.com'
  AND b.pickup_location = 'Surulere';

-- TEST 14: Booking service type must be allowed.
-- Expected error: CHECK constraint violation on service_type.
INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'taxi', 'Test Pickup', 'Test Destination',
       CURRENT_TIMESTAMP, 'requested'
FROM public.customer
WHERE email = 'ada@example.com';

-- TEST 15: Booking status must be allowed.
-- Expected error: CHECK constraint violation on status.
INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'goods delivery', 'Test Pickup',
       'Test Destination', CURRENT_TIMESTAMP, 'pending'
FROM public.customer
WHERE email = 'ada@example.com';

-- TEST 16: A booking can have at most one trip.
-- Expected error: duplicate key violates trip.booking_id uniqueness.
INSERT INTO public.trip (booking_id, driver_id)
SELECT t.booking_id, d.driver_id
FROM public.trip t
CROSS JOIN public.driver d
WHERE t.booking_id = (
    SELECT b.booking_id
    FROM public.booking b
    JOIN public.customer c ON c.customer_id = b.customer_id
    WHERE c.email = 'ada@example.com'
      AND b.pickup_location = 'CMS'
)
AND d.licence_number = 'LIC-102';

-- Final row counts: run after all failed INSERT statements.
SELECT 'customer' AS table_name, COUNT(*) AS row_count
FROM public.customer
UNION ALL
SELECT 'driver', COUNT(*) FROM public.driver
UNION ALL
SELECT 'vehicle', COUNT(*) FROM public.vehicle
UNION ALL
SELECT 'booking', COUNT(*) FROM public.booking
UNION ALL
SELECT 'trip', COUNT(*) FROM public.trip;
