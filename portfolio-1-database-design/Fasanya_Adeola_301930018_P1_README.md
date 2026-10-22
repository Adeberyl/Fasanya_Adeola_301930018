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

### Excluded from Scope

- Online payments
- Live GPS tracking
- Route optimisation
- Customer ratings
- Driver payroll
- Vehicle maintenance
- Integration with external mapping or payment services