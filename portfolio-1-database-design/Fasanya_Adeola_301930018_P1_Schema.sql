
-- MIT 8103 Portfolio 1
-- Ride-hailing and Logistics System
-- PostgreSQL 16 schema

BEGIN;

-- Registered customers
CREATE TABLE public.customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE
);

-- Registered drivers and availability
CREATE TABLE public.driver (
    driver_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    licence_number VARCHAR(50) NOT NULL UNIQUE,
    is_available BOOLEAN NOT NULL
);

-- One vehicle per driver
CREATE TABLE public.vehicle (
    vehicle_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    registration_number VARCHAR(20) NOT NULL UNIQUE,
    driver_id BIGINT NOT NULL UNIQUE,
    CONSTRAINT fk_vehicle_driver
        FOREIGN KEY (driver_id)
        REFERENCES public.driver (driver_id)
);

-- Customer ride and delivery requests
CREATE TABLE public.booking (
    booking_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    service_type VARCHAR(20) NOT NULL,
    pickup_location VARCHAR(200) NOT NULL,
    destination VARCHAR(200) NOT NULL,
    requested_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_booking_customer
        FOREIGN KEY (customer_id)
        REFERENCES public.customer (customer_id),

    CONSTRAINT chk_booking_service_type
        CHECK (service_type IN ('passenger ride', 'goods delivery')),

    CONSTRAINT chk_booking_status
        CHECK (status IN (
            'requested',
            'assigned',
            'in progress',
            'completed',
            'cancelled'
        ))
);

-- Assigned trips and journey details
CREATE TABLE public.trip (
    trip_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT NOT NULL UNIQUE,
    driver_id BIGINT NOT NULL,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    fare NUMERIC(10,2),

    CONSTRAINT fk_trip_booking
        FOREIGN KEY (booking_id)
        REFERENCES public.booking (booking_id),

    CONSTRAINT fk_trip_driver
        FOREIGN KEY (driver_id)
        REFERENCES public.driver (driver_id)
);

-- Additional business rules require triggers or transaction logic:
-- 1. requested_at must not be in the past when a booking is created.
-- 2. Trip assignment must check driver availability.
-- 3. Drivers and vehicles must not have overlapping active trips.
-- 4. Completed bookings must have a recorded fare.
-- 5. Cancelled bookings cannot subsequently be completed.
-- 6. Assignment operations must maintain booking and trip status consistently.
-- These rules are not fully enforced by the table definitions alone.

COMMIT;
