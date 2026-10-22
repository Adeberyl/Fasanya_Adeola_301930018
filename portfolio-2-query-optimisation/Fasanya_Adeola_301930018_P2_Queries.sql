-- Query 1: Booking details with customer and trip information
SELECT
    b.booking_id,
    c.full_name AS customer_name,
    b.service_type,
    b.pickup_location,
    b.destination,
    b.status AS booking_status,
    d.full_name AS driver_name,
    t.fare
FROM public.booking AS b
JOIN public.customer AS c
    ON c.customer_id = b.customer_id
LEFT JOIN public.trip AS t
    ON t.booking_id = b.booking_id
LEFT JOIN public.driver AS d
    ON d.driver_id = t.driver_id
WHERE b.status IN ('completed', 'assigned', 'in progress')
ORDER BY b.booking_id ASC;


-- Query 2: Available drivers without an assigned active trip
SELECT
    d.driver_id,
    d.full_name,
    d.licence_number,
    d.is_available
FROM public.driver AS d
WHERE d.is_available = TRUE
  AND NOT EXISTS (
      SELECT 1
      FROM public.trip AS t
      JOIN public.booking AS b
          ON b.booking_id = t.booking_id
      WHERE t.driver_id = d.driver_id
        AND b.status IN ('assigned', 'in progress')
  )
ORDER BY d.driver_id ASC;

-- Query 3: Booking count for every customer
SELECT
    c.customer_id,
    c.full_name,
    COUNT(b.booking_id) AS total_bookings
FROM public.customer AS c
LEFT JOIN public.booking AS b
    ON b.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.full_name
ORDER BY
    c.customer_id ASC;