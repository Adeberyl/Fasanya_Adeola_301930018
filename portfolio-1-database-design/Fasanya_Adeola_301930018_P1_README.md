# Portfolio 1: Database Design and Modelling

## Case Study

A ride-hailing and logistics system manages customers, drivers, vehicles, bookings, and trips for transporting passengers or delivering goods. Customers request rides or deliveries, while drivers accept assigned requests and update their progress. The system records trip details, fares, and completion status to support daily operations.

---

## Users

| User Type | Responsibilities |
|-----------|------------------|
| **Customers** | Request rides or deliveries and view their booking status and trip history. |
| **Drivers** | Manage their availability, accept requests, and update trip statuses. |
| **Administrator** | Registers customers and drivers, maintains vehicle records, monitors bookings, and reviews completed trips. |

---

## Main Operations

1. Register a customer
2. Register a driver and their vehicle
3. Create a ride or delivery booking
4. Assign an available driver to a booking
5. Update the booking and trip status
6. Record the fare and trip completion details
7. View booking history and driver activity

---

## Business Rules

| # | Rule |
|---|------|
| 1 | Each customer has a unique **customer ID** and **email address**. |
| 2 | Each driver has a unique **driver ID** and **licence number**. |
| 3 | Each vehicle has a unique **vehicle registration number** and is assigned to **one registered driver at a time**. |
| 4 | Each booking has a unique **booking ID** and belongs to **one customer**. |
| 5 | Each booking must specify a **service type** of either *passenger ride* or *goods delivery*, a **pickup location**, and a **destination**. |
| 6 | Each booking has a **scheduled request date and time**, which **cannot be in the past** when the booking is created. |
| 7 | A booking can be assigned to **at most one driver**, and only a **registered, available driver** can accept an assignment. |
| 8 | A driver **cannot accept overlapping active bookings**, and a vehicle **cannot be used for conflicting trips**. |
| 9 | Each booking has a **status** of `requested`, `assigned`, `in progress`, `completed`, or `cancelled`. A **completed trip must have a recorded fare**, and a **cancelled booking cannot subsequently be completed**. |

---

## Scope

The system covers **one fictional ride-hailing and delivery service**, using fictional customers, drivers, vehicles, locations, and booking records. It includes:

- Booking management
- Driver assignment
- Trip status tracking
- Fare recording

# Design and Implementation Files

## Files

/workspaces/Fasanya_Adeola_301930018/portfolio-1-database-design

| File | Contents |
|------|----------|
| `Fasanya_Adeola_301930018_P1_Design.md` | Database entities, attributes, keys, relationships and business rules. |
| `Fasanya_Adeola_301930018_P1_ERDiagram.md` | Mermaid ER diagram showing the five tables and their relationships. |
| `Fasanya_Adeola_301930018_P1_Normalisation.md` | Examples explaining First, Second and Third Normal Forms (1NF, 2NF and 3NF). |
| `Fasanya_Adeola_301930018_P1_Schema.sql` | PostgreSQL table definitions, primary keys, foreign keys, unique constraints and CHECK constraints. |
| `Fasanya_Adeola_301930018_P1_SampleData.sql` | SQL statements for inserting fictional customers, drivers, vehicles, bookings and trips. |
| `Fasanya_Adeola_301930018_P1_ConstraintTests.sql` | Invalid INSERT statements for testing database constraints and a final row-count query. |
| `screenshots/` | Directory for database commands and test-result screenshots. |

---

## Implementation

I use **PostgreSQL 16** and the database `ride_logistics_portfolio` for my Ride-hailing and Logistics System. The schema contains five tables: `customer`, `driver`, `vehicle`, `booking` and `trip`. It uses automatically generated identity primary keys, foreign keys, unique constraints, required fields and CHECK constraints to maintain data integrity.

I use the supplied sample-data file to populate the tables and the constraint-test file to check how PostgreSQL responds to invalid records. The tests target required fields, duplicate values, foreign keys and permitted booking values. I run the negative test statements separately so that an expected error does not prevent subsequent tests from running.

---

## Test Results

The observed PostgreSQL results confirm that the database rejects a duplicate vehicle registration number (`LAG-123-AB`) with a unique-constraint error. The database also rejects a booking that references the nonexistent customer ID `-999999`, returning a foreign-key violation. These results demonstrate that the corresponding constraints prevent invalid records from being inserted.

The final row-count query returns **2 customers, 3 drivers, 3 vehicles, 5 bookings and 3 trips**. These counts match the expected sample-data totals and show no additional records from the two rejected statements. The observed results confirm these two constraint failures and the reported row counts; they do not establish that every other test has been executed successfully.

The schema does not independently enforce all business rules. Checking that booking request times are not in the past, verifying driver availability during assignment, preventing overlapping active trips, requiring a fare for completed bookings and preventing cancelled bookings from subsequently being completed require additional transaction logic or triggers. These rules remain limitations of the current implementation.

### Excluded from Scope

- Online payments
- Live GPS tracking
- Route optimisation
- Customer ratings
- Driver payroll
- Vehicle maintenance
- Integration with external mapping or payment services