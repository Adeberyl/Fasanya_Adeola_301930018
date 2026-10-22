# Ride-hailing / Logistics System ER Diagram

```mermaid
erDiagram
    direction LR

    customer {
        BIGINT customer_id PK
        VARCHAR(120) full_name
        VARCHAR(254) email UK
    }

    driver {
        BIGINT driver_id PK
        VARCHAR(120) full_name
        VARCHAR(50) licence_number UK
        BOOLEAN is_available
    }

    vehicle {
        BIGINT vehicle_id PK
        VARCHAR(20) registration_number UK
        BIGINT driver_id FK, UK
    }

    booking {
        BIGINT booking_id PK
        BIGINT customer_id FK
        VARCHAR(20) service_type
        VARCHAR(200) pickup_location
        VARCHAR(200) destination
        TIMESTAMPTZ requested_at
        VARCHAR(20) status
    }

    trip {
        BIGINT trip_id PK
        BIGINT booking_id FK, UK
        BIGINT driver_id FK
        TIMESTAMPTZ started_at
        TIMESTAMPTZ completed_at
        NUMERIC(10,2) fare
    }

    customer ||--o{ booking : requests
    driver ||--|| vehicle : assigned
    booking ||--o| trip : generates
    driver ||--o{ trip : completes
```

## Explanation of Keys and Relationships

### 1. Keys

- **PK (Primary Key):** Uniquely identifies each record in a table. For example, `customer_id` identifies each customer.
- **FK (Foreign Key):** Links a record to an existing record in another table. For example, `booking.customer_id` references `customer.customer_id`.
- **UK (Unique Key):** Prevents duplicate values in a field. For example, `customer.email` ensures that two customers cannot share the same email address.

### 2. Relationship symbols

The diagram uses the following Mermaid ER relationship symbols:

| Symbol | Meaning |
|---|---|
| `||` | Exactly one |
| `o|` | Zero or one |
| `o{` | Zero or many |

The relationships represent these rules:

- **Customer to booking (`||--o{`):** Each booking belongs to exactly one customer, while a customer can have zero or many bookings.
- **Driver to vehicle (`||--||`):** Each driver has exactly one vehicle, and each vehicle belongs to exactly one driver.
- **Booking to trip (`||--o|`):** Each trip belongs to exactly one booking, while a booking can have zero or one trip.
- **Driver to trip (`||--o{`):** Each trip has exactly one assigned driver, while a driver can complete zero or many trips over time.

For example, a customer requests a goods delivery through a booking. The booking records the pickup location, destination and request time. When a driver is assigned, a trip records the driver, journey progress and fare. Keeping booking and trip separate distinguishes the original request from its execution.

## Optional Fields

The following trip fields are optional until applicable:

- `started_at`: Records when the trip starts.
- `completed_at`: Records when the trip finishes.
- `fare`: Records the trip's monetary fare.

All other fields are required according to the design. The diagram identifies primary keys, foreign keys and unique fields; required and optional status is described here.

## Additional Constraints and Transaction Logic

Some business rules require additional database constraints, triggers or application-level transaction logic:

- **Service type:** A `CHECK` constraint restricts `service_type` to passenger ride or goods delivery.
- **Booking status:** A `CHECK` constraint restricts `status` to requested, assigned, in progress, completed or cancelled.
- **Request date:** A trigger or application operation checks that `requested_at` is not in the past when a booking is created.
- **Driver availability:** Assignment logic checks that the driver is available before assigning a trip.
- **Conflicting trips:** Transaction logic checks that a driver and vehicle are not committed to overlapping active trips.
- **Completion and cancellation:** Transaction logic ensures that completed bookings have a recorded fare and cancelled bookings cannot subsequently be completed.

These rules complement the primary keys, foreign keys and unique constraints. Together, they support the accurate recording of customer requests, vehicle assignments and trip details in the ride-hailing and logistics system.