# Ride-hailing and Logistics System Normalisation

Normalisation is the process of organising information into related tables to reduce repeated data and prevent problems when records are inserted, updated or deleted. In my ride-hailing and logistics system, normalisation separates customer details, driver details, vehicle details, booking requests and trip information into five related tables.

The examples below use fictional records and selected fields for readability. They illustrate how the data is organised from an initial booking list through First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

---

## Starting Booking List

The initial record combines customer details, booking information and trip details. A customer can make several bookings, so the **Bookings** column contains a repeated list.

| customer_id | full_name | email | Bookings |
|-------------|-----------|-------|----------|
| 1 | Ada James | ada@example.com | Booking 101: passenger ride, CMS to Victoria Island, driver 10, fare ₦3,500; Booking 102: goods delivery, Ikeja to Yaba, driver 11, fare ₦5,000 |
| 2 | Ben Cole | ben@example.com | Booking 103: passenger ride, Lekki to Ikoyi, driver 10, fare ₦4,000 |

The **Bookings** column contains multiple booking records in one cell. This makes it difficult to search for an individual booking, update its details or record its trip separately. Customer and driver details can also become repeated as the number of bookings increases.

---

## 1NF: One Value per Cell

First Normal Form (1NF) means each cell contains a single value, and each row represents one record rather than a list of records.

The repeated booking list is separated into individual booking records. The table below shows selected customer, booking and trip fields.

| booking_id | customer_id | full_name | email | service_type | pickup_location | destination | driver_id | fare |
|------------|-------------|-----------|-------|--------------|-----------------|-------------|-----------|------|
| 101 | 1 | Ada James | ada@example.com | passenger ride | CMS | Victoria Island | 10 | 3500.00 |
| 102 | 1 | Ada James | ada@example.com | goods delivery | Ikeja | Yaba | 11 | 5000.00 |
| 103 | 2 | Ben Cole | ben@example.com | passenger ride | Lekki | Ikoyi | 10 | 4000.00 |

**Key:** `booking_id` uniquely identifies each booking in this example. `customer_id` and `driver_id` identify the related customer and driver.

**What changes:** Each booking occupies its own row, so the system can find and update individual bookings. However, Ada's name and email repeat for bookings 101 and 102. Driver 10 also appears in more than one record. Repetition remains even though the table satisfies 1NF.

---

## 2NF: Details Depend on the Whole Key

Second Normal Form (2NF) includes 1NF. Every non-key field must depend on the whole primary key, not just part of a combined key.

In the 1NF example, `booking_id` is a single-field primary key. It uniquely identifies each booking, so there is no combined key with a part on which a non-key field depends. Therefore, the example is **already in 2NF**. I do not introduce a false partial dependency just to demonstrate a change.

The following table remains unchanged at this stage.

### Booking and Trip Information

| booking_id (PK) | customer_id | full_name | email | service_type | pickup_location | destination | driver_id | fare |
|-----------------|-------------|-----------|-------|--------------|-----------------|-------------|-----------|------|
| 101 | 1 | Ada James | ada@example.com | passenger ride | CMS | Victoria Island | 10 | 3500.00 |
| 102 | 1 | Ada James | ada@example.com | goods delivery | Ikeja | Yaba | 11 | 5000.00 |
| 103 | 2 | Ben Cole | ben@example.com | passenger ride | Lekki | Ikoyi | 10 | 4000.00 |

**Key:** `booking_id` is the primary key. `customer_id` and `driver_id` are intended to reference customer and driver records.

Although this table satisfies 2NF, customer details still repeat across bookings. Driver details would also repeat if their names and licence numbers were included. These details describe customers and drivers rather than individual bookings. This remaining issue is addressed in 3NF.

---

## 3NF: Keep Details with the Entity They Describe

Third Normal Form (3NF) includes 2NF. A non-key field must depend on the primary key, the whole key and nothing but the key. In simple terms, details belong in the table for the thing they describe, rather than depending on another non-key field.

The following dependencies explain the separation:

- `customer_id` determines `full_name` and `email`.
- `driver_id` determines `full_name`, `licence_number` and `is_available`.
- `vehicle_id` identifies a vehicle, while its `driver_id` links it to its driver.
- `booking_id` identifies a booking and its customer, service and location details.
- `trip_id` identifies a trip, while `booking_id` and `driver_id` link it to the booking and assigned driver.

The final design separates these details into five related tables.

### 1. Customer Table

**Key:** `customer_id` (PK). `email` is unique (UK).

| customer_id (PK) | full_name | email (UK) |
|------------------|-----------|------------|
| 1 | Ada James | ada@example.com |
| 2 | Ben Cole | ben@example.com |

Customer names and email addresses are stored once per customer rather than repeated in every booking.

### 2. Driver Table

**Key:** `driver_id` (PK). `licence_number` is unique (UK).

| driver_id (PK) | full_name | licence_number (UK) | is_available |
|----------------|-----------|---------------------|--------------|
| 10 | Chris Okafor | LIC-100 | TRUE |
| 11 | David Bello | LIC-101 | TRUE |

Driver details are stored separately from bookings and trips. A driver's licence number and availability are maintained in the driver record.

### 3. Vehicle Table

**Key:** `vehicle_id` (PK). `registration_number` and `driver_id` are unique (UK). `driver_id` is also a foreign key (FK).

| vehicle_id (PK) | registration_number (UK) | driver_id (FK, UK) |
|-----------------|--------------------------|--------------------|
| 201 | LAG-123-AB | 10 |
| 202 | LAG-456-CD | 11 |

Each vehicle belongs to one driver, and the unique `driver_id` enforces one vehicle per driver under the agreed design.

### 4. Booking Table

**Key:** `booking_id` (PK). `customer_id` is a foreign key (FK).

| booking_id (PK) | customer_id (FK) | service_type | pickup_location | destination | requested_at | status |
|-----------------|------------------|--------------|-----------------|-------------|--------------|--------|
| 101 | 1 | passenger ride | CMS | Victoria Island | 2026-10-01 09:00 | completed |
| 102 | 1 | goods delivery | Ikeja | Yaba | 2026-10-02 10:00 | completed |
| 103 | 2 | passenger ride | Lekki | Ikoyi | 2026-10-03 11:00 | completed |

Each booking stores the customer's request. The customer name and email are not repeated because `customer_id` links the booking to the customer table.

### 5. Trip Table

**Key:** `trip_id` (PK). `booking_id` is a foreign key and unique (FK, UK). `driver_id` is a foreign key (FK).

| trip_id (PK) | booking_id (FK, UK) | driver_id (FK) | started_at | completed_at | fare |
|--------------|---------------------|----------------|------------|--------------|------|
| 301 | 101 | 10 | 2026-10-01 09:10 | 2026-10-01 09:35 | 3500.00 |
| 302 | 102 | 11 | 2026-10-02 10:15 | 2026-10-02 11:00 | 5000.00 |
| 303 | 103 | 10 | 2026-10-03 11:10 | 2026-10-03 11:40 | 4000.00 |

The trip table records the assigned driver, journey times and fare. A unique `booking_id` means each booking has at most one trip record. A booking can exist before its trip is assigned.

> The dates and values are illustrative examples, not executed database records.

---

## How the Tables Remain Linked

The primary and foreign keys preserve the relationships between the five tables:

- `customer.customer_id` links to `booking.customer_id`.
- `driver.driver_id` links to `vehicle.driver_id` and `trip.driver_id`.
- `booking.booking_id` links to `trip.booking_id`.
- `vehicle.vehicle_id` identifies each vehicle independently.

A foreign key is a field that references a key in another table. These links allow the system to retrieve customer, booking, driver, vehicle and trip details together without storing every detail repeatedly.

For example, booking 101 belongs to customer 1 and has trip 301 assigned to driver 10. The system obtains Ada James's contact details from the customer table and Chris Okafor's driver details from the driver table.

---

## Automatically Generated IDs and Fields Omitted from the Examples

The final design uses automatically generated IDs as primary keys, including `customer_id`, `driver_id`, `vehicle_id`, `booking_id` and `trip_id`. These IDs provide stable identifiers for records. They do not, by themselves, prove that a table satisfies 3NF; the dependencies between fields determine whether the table is normalised.

The final tables above include all the attributes in the agreed database design. PostgreSQL types remain as specified: `BIGINT`, `VARCHAR` with the agreed lengths, `BOOLEAN`, `TIMESTAMPTZ` and `NUMERIC(10,2)`. Some values are shortened or omitted from the displayed tables only where not needed to explain normalisation; no agreed attributes are removed from the final design.

---

## Additional Business Rules

Normalisation reduces duplication, but it does not automatically enforce every business rule. The design also requires:

- Unique constraints on customer email, driver licence number, vehicle registration number, vehicle `driver_id` and trip `booking_id`.
- A `CHECK` constraint limiting `service_type` to *passenger ride* or *goods delivery* and `status` to the five agreed booking statuses.
- A trigger or application operation checking that `requested_at` is not in the past when a booking is created.
- Assignment logic checking driver availability and preventing multiple trips for one booking.
- Transaction logic preventing overlapping active trips for a driver or vehicle.
- Transaction logic ensuring completed bookings have a recorded fare and cancelled bookings cannot subsequently be completed.

---

## Conclusion

The ride-hailing and logistics database uses normalisation to reduce repeated customer and driver information, separate booking requests from trip execution, and maintain relationships through primary and foreign keys. The five-table design supports more consistent data management while retaining the business rules required by the system.