-- SampleData.sql
-- Fictional records for the ride-hailing and logistics system.

BEGIN;

-- 1. Add customers first.
INSERT INTO public.customer (full_name, email)
VALUES
    ('Ada James', 'ada@example.com'),
    ('Ben Cole', 'ben@example.com');

-- 2. Add drivers.
INSERT INTO public.driver (full_name, licence_number, is_available)
VALUES
    ('Chris Okafor', 'LIC-100', FALSE),
    ('David Bello', 'LIC-101', FALSE),
    ('Efe Daniel', 'LIC-102', TRUE);

-- 3. Give each driver one vehicle.
INSERT INTO public.vehicle (registration_number, driver_id)
SELECT 'LAG-123-AB', driver_id
FROM public.driver WHERE licence_number = 'LIC-100';

INSERT INTO public.vehicle (registration_number, driver_id)
SELECT 'LAG-456-CD', driver_id
FROM public.driver WHERE licence_number = 'LIC-101';

INSERT INTO public.vehicle (registration_number, driver_id)
SELECT 'LAG-789-EF', driver_id
FROM public.driver WHERE licence_number = 'LIC-102';

-- 4. Add bookings for different service and status examples.
INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'passenger ride', 'CMS', 'Victoria Island',
       CURRENT_TIMESTAMP, 'completed'
FROM public.customer WHERE email = 'ada@example.com';

INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'goods delivery', 'Ikeja', 'Yaba',
       CURRENT_TIMESTAMP, 'assigned'
FROM public.customer WHERE email = 'ada@example.com';

INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'passenger ride', 'Lekki', 'Ikoyi',
       CURRENT_TIMESTAMP, 'in progress'
FROM public.customer WHERE email = 'ben@example.com';

INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'goods delivery', 'Surulere', 'Apapa',
       CURRENT_TIMESTAMP, 'requested'
FROM public.customer WHERE email = 'ben@example.com';

INSERT INTO public.booking
    (customer_id, service_type, pickup_location, destination,
     requested_at, status)
SELECT customer_id, 'passenger ride', 'Yaba', 'Maryland',
       CURRENT_TIMESTAMP, 'cancelled'
FROM public.customer WHERE email = 'ada@example.com';

-- 5. Add trips for completed, assigned and in-progress bookings.
-- IDs are looked up using customer emails and pickup locations.

INSERT INTO public.trip
    (booking_id, driver_id, started_at, completed_at, fare)
SELECT b.booking_id, d.driver_id,
       CURRENT_TIMESTAMP - INTERVAL '45 minutes',
       CURRENT_TIMESTAMP - INTERVAL '20 minutes',
       3500.00
FROM public.booking b
JOIN public.customer c ON c.customer_id = b.customer_id
JOIN public.driver d ON d.licence_number = 'LIC-100'
WHERE c.email = 'ada@example.com'
  AND b.pickup_location = 'CMS';

INSERT INTO public.trip
    (booking_id, driver_id, started_at, completed_at, fare)
SELECT b.booking_id, d.driver_id, NULL, NULL, NULL
FROM public.booking b
JOIN public.customer c ON c.customer_id = b.customer_id
JOIN public.driver d ON d.licence_number = 'LIC-101'
WHERE c.email = 'ada@example.com'
  AND b.pickup_location = 'Ikeja';

INSERT INTO public.trip
    (booking_id, driver_id, started_at, completed_at, fare)
SELECT b.booking_id, d.driver_id,
       CURRENT_TIMESTAMP - INTERVAL '10 minutes',
       NULL, NULL
FROM public.booking b
JOIN public.customer c ON c.customer_id = b.customer_id
JOIN public.driver d ON d.licence_number = 'LIC-100'
WHERE c.email = 'ben@example.com'
  AND b.pickup_location = 'Lekki';

COMMIT;
