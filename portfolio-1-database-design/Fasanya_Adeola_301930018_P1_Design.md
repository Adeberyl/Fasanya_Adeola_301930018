# Ride-hailing and Logistics System Database Design

## 1. Entities

I chose five entities for the ride-hailing and logistics system.

| Entity | Information stored |
|--------|--------------------|
| **customer** | A registered customer who requests rides or deliveries |
| **driver** | A registered driver and their availability |
| **vehicle** | A vehicle used by a driver |
| **booking** | A passenger ride or goods delivery request |
| **trip** | The assigned driver, trip progress, completion details and fare |

I keep **booking** and **trip** separate because a booking records the customer's request, while a trip records its assignment and journey details. For example, a customer creates a booking to travel from one location to another, and the assigned driver completes the trip.

---

## 2. Attributes and Keys

I use automatically generated IDs as primary keys (PKs). A foreign key (FK) links a record to another table. **Unique** means a value cannot be repeated; **required** means it cannot be NULL.

| Entity | Attributes and proposed PostgreSQL types | Keys and required values |
|--------|------------------------------------------|--------------------------|
| **customer** | `customer_id BIGINT`; `full_name VARCHAR(120)`; `email VARCHAR(254)` | **PK:** `customer_id`. **Unique:** `email`. All required. |
| **driver** | `driver_id BIGINT`; `full_name VARCHAR(120)`; `licence_number VARCHAR(50)`; `is_available BOOLEAN` | **PK:** `driver_id`. **Unique:** `licence_number`. All required. |
| **vehicle** | `vehicle_id BIGINT`; `registration_number VARCHAR(20)`; `driver_id BIGINT` | **PK:** `vehicle_id`. **FK:** `driver_id → driver.driver_id`. **Unique:** `registration_number` and `driver_id`. All required. |
| **booking** | `booking_id BIGINT`; `customer_id BIGINT`; `service_type VARCHAR(20)`; `pickup_location VARCHAR(200)`; `destination VARCHAR(200)`; `requested_at TIMESTAMPTZ`; `status VARCHAR(20)` | **PK:** `booking_id`. **FK:** `customer_id → customer.customer_id`. All required. |
| **trip** | `trip_id BIGINT`; `booking_id BIGINT`; `driver_id BIGINT`; `started_at TIMESTAMPTZ`; `completed_at TIMESTAMPTZ`; `fare NUMERIC(10,2)` | **PK:** `trip_id`. **FKs:** `booking_id → booking.booking_id`; `driver_id → driver.driver_id`. **Unique:** `booking_id`. `started_at`, `completed_at` and `fare` are optional until applicable. Other fields are required. |

`BIGINT` stores whole numbers, `VARCHAR` stores text, `BOOLEAN` stores true or false, `TIMESTAMPTZ` stores date and time, and `NUMERIC(10,2)` stores monetary values.

---

## 3. Relationships

| Tables linked | Relationship | Meaning |
|---------------|--------------|---------|
| `customer → booking` | One to many | A customer can have zero or many bookings; each booking belongs to exactly one customer. |
| `driver → vehicle` | One to one | Each driver has one vehicle, and each vehicle belongs to one driver. |
| `booking → trip` | One to zero or one | A booking can have no trip before assignment or one trip; each trip belongs to exactly one booking. |
| `driver → trip` | One to many | A driver can have zero or many trips over time; each trip has exactly one assigned driver. |

I use **trip** to connect bookings and drivers without duplicating customer and booking details. A unique `booking_id` in `trip` prevents a booking from having multiple trip records.

---

## 4. Business Rules and Constraints

- **Unique identifiers:** Primary keys identify customers and drivers. Unique constraints enforce customer email and driver licence number.
- **Vehicle registration:** A unique constraint enforces vehicle registration numbers. A unique `driver_id` enforces one vehicle per driver.
- **Booking ownership:** A primary key identifies each booking, and a foreign key requires its customer to exist.
- **Service and locations:** A `CHECK` constraint restricts `service_type` to *passenger ride* or *goods delivery*. Pickup and destination are required.
- **Request date:** `requested_at` is required. A database trigger or application operation checks that it is not in the past when the booking is created.
- **Driver assignment:** Foreign keys require an existing booking and driver. Assignment operations check driver availability and prevent multiple trips for one booking.
- **Conflicting trips:** Transaction logic checks that a driver and vehicle are not already committed to overlapping active trips. A simple unique key cannot enforce time overlap.
- **Trip status and fare:** A `CHECK` constraint restricts booking status to `requested`, `assigned`, `in progress`, `completed` or `cancelled`. Transaction logic ensures completed bookings have a recorded fare and cancelled bookings cannot subsequently be completed.