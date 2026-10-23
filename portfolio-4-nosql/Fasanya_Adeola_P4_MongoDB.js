
/*
 * MIT 8103 Portfolio 4
 * Ride-hailing and Logistics System
 * MongoDB 8.0.4
 *
 * These are separate fictional MongoDB examples.
 * They are not imported from the PostgreSQL database.
 */

use("ride_logistics_p4");

db.createCollection("activity_events");

db.activity_events.insertMany([
  {
    _id: "EVT-001",
    eventType: "booking_status_changed",
    eventTime: ISODate("2026-09-10T08:00:00Z"),
    booking: {
      bookingRef: "P4-BKG-001",
      serviceType: "passenger ride"
    },
    customer: {
      email: "ada@example.com"
    },
    details: {
      previousStatus: "requested",
      newStatus: "assigned",
      pickupLocation: "CMS",
      destination: "Victoria Island"
    }
  },
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
  },
  {
    _id: "EVT-003",
    eventType: "booking_status_changed",
    eventTime: ISODate("2026-09-11T09:00:00Z"),
    booking: {
      bookingRef: "P4-BKG-002",
      serviceType: "goods delivery"
    },
    customer: {
      email: "ada@example.com"
    },
    details: {
      previousStatus: "requested",
      newStatus: "assigned",
      pickupLocation: "Ikeja",
      destination: "Yaba"
    }
  },
  {
    _id: "EVT-004",
    eventType: "trip_completed",
    eventTime: ISODate("2026-09-12T14:30:00Z"),
    booking: {
      bookingRef: "P4-BKG-003",
      serviceType: "passenger ride"
    },
    customer: {
      email: "ben@example.com"
    },
    driver: {
      licenceNumber: "LIC-100"
    },
    details: {
      finalStatus: "completed",
      fare: 4200.00,
      currency: "NGN",
      pickupLocation: "Lekki",
      destination: "Ikoyi"
    }
  }
]);

//This query retrieves Ada's events from oldest to newest.
db.activity_events.find(
  { "customer.email": "ada@example.com" }
).sort({ eventTime: 1 })

//Find completed-trip events with a fare greater than ₦3,000.
db.activity_events.find({
  eventType: "trip_completed",
  "details.fare": { $gt: 3000 }
})