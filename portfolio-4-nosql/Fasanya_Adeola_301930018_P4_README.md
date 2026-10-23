# Portfolio 4 NoSQL and Advanced Data Models

## Document model

This portfolio implements a small MongoDB document model for the Ride-hailing and Logistics System developed in Portfolio 1. It records booking status changes and trip completion events in one database, `ride_logistics_p4`, using one collection, `activity_events`.

Each event document contains a unique string `_id`, an `eventType`, an `eventTime`, and embedded documents for `booking` and `customer` information. Driver information is included where relevant. The `details` embedded document varies according to the event type: booking status events record the previous and new statuses, while trip completion events record the final status, fare, currency and journey locations.

The collection contains four fictional event documents with fixed timestamps. The examples reuse fictional customer emails and a driver licence number from Portfolio 1. The booking references and event IDs are example identifiers created for this MongoDB implementation.

**Example document:**

```json
{
  _id: "EVT-002",
  eventType: "trip_completed",
  eventTime: ISODate("2026-09-10T08:35:00Z"),
  booking: {
    bookingRef: "P4-BKG-001",
    serviceType: "passenger ride"
  },
  customer: {
    email: "ada@example.com"
  },
  driver: {
    licenceNumber: "LIC-100"
  },
  details: {
    finalStatus: "completed",
    fare: 3500.00,
    currency: "NGN",
    pickupLocation: "CMS",
    destination: "Victoria Island"
  }
}
```

These documents are separate MongoDB examples, not records automatically imported from PostgreSQL. Portfolio 1 remains unchanged.

## Implementation and results

The implementation uses **MongoDB 8.0.4** and `mongosh`. The database was selected, the `activity_events` collection was created successfully, and the four example documents were available for querying.

Three queries were executed:

1. **Total event count:** `countDocuments({})` returned **4**.
2. **Customer event history:** filtering on `customer.email` for `ada@example.com` and sorting by `eventTime` in ascending order returned three events: `EVT-001`, `EVT-002` and `EVT-003`.
3. **Nested fare filter:** filtering for `eventType: "trip_completed"` and `details.fare` greater than `3000` returned `EVT-002` with a fare of ₦3,500 and `EVT-004` with a fare of ₦4,200.

The results demonstrate document counting, retrieval of ordered customer activity, and filtering using a nested numeric field.

The query results were observed in the terminal. The initial collection count and complete insertion acknowledgement were not captured in the supplied output.

## Why MongoDB fits

MongoDB's document model is suitable for this activity-event example because related booking, customer and driver details can be stored together in a single document. Embedded documents make the event structure readable, while the varying `details` fields accommodate different event types without requiring every event to contain identical fields.

The model also supports straightforward filtering and chronological retrieval using nested-field queries and date sorting.

A limitation is that this small implementation does not enforce all the business rules in Portfolio 1. For example, it does not prevent overlapping trips, verify driver availability during assignment, or guarantee valid booking-status transitions. These rules would require additional validation and transaction logic for a production system.

## Files

- [`Fasanya_Adeola_301930018_P4_MongoDB.js`](portfolio-4-nosql/Fasanya_Adeola_P4_MongoDB.js) — MongoDB collection setup and the four example event documents.
- [`screenshots/P4_MongoDB_Query_Results.png`](portfolio-4-nosql/Screenshots) — screenshot of the three query results, to be added after capturing the terminal.
- [`../portfolio-1-database-design/Fasanya_Adeola_301930018_P1_Design.md`](portfolio-1-database-design/Fasanya_Adeola_301930018_P1_Design.md) — original relational database design, if the stated relative folder structure is maintained.

## References

- MongoDB Documentation. *Databases and Collections*. https://www.mongodb.com/docs/manual/core/databases-and-collections/
- MongoDB Documentation.