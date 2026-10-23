# Portfolio 3 Transactions and Concurrency

## Commit and rollback

I used PostgreSQL transactions to test changes in my ride-hailing and logistics database, `ride_logistics_portfolio`. I updated a booking from `assigned` to `in progress` inside a transaction and used `COMMIT` to save the change. I also tested a deliberate violation of the `chk_booking_status` constraint after a valid update and used `ROLLBACK` to undo the transaction. The expected results were `UPDATE 1` for a successful update, a constraint error for the invalid status, and restoration of the original status after rollback. These results must be confirmed against the actual query output.

## Isolation and concurrency control

I designed a two-session concurrency test using the `READ COMMITTED` isolation level in two independent PostgreSQL connections. Both sessions attempted to insert a trip for booking 4 using driver 3. The existing `UNIQUE` constraint on `public.trip.booking_id` should make Session B wait while Session A holds its uncommitted insert. If Session A commits, Session B should receive a unique-constraint error, and its transaction can be ended with `ROLLBACK`. The final query should show one trip for booking 4. These are predicted results until confirmed by the session output and screenshots. This constraint prevents duplicate trips for the same booking, but it does not prevent overlapping trips for the same driver across different bookings.

## Conclusion

The exercises demonstrate how `COMMIT` saves a transaction, `ROLLBACK` cancels uncommitted changes, and an existing unique constraint can protect booking-to-trip relationships during concurrent inserts. The tests also highlight a limitation of the current schema: driver availability and overlapping active trips are not fully enforced by the existing table constraints. Actual query results and screenshots are required to confirm the outcomes before reporting the tests as successful.

## Files

- [`Fasanya_Adeola_301930018_P1_Schema.sql`](portfolio-1-database-design/Fasanya_Adeola_301930018_P1_Schema.sql) — Creates the five database tables and their constraints.
- [`Fasanya_Adeola_301930018_P1_SampleData.sql`](portfolio-1-database-design/Fasanya_Adeola_301930018_P1_SampleData.sql) — Inserts the fictional customers, drivers, vehicles, bookings and trips.
- [`Fasanya_Adeola_301930018_P1_ConstraintTests.sql`](portfolio-1-database-design/Fasanya_Adeola_301930018_P1_ConstraintTests.sql) — Tests existing database constraints.
- [`Fasanya_Adeola_301930018_P3_Transactions.sql`](./portfolio-3-transactions-concurrency/Fasanya_Adeola_301930018_P3_Transactions.sql) — Commit and rollback exercise, if saved under this filename.
- [`screenshots/`](portfolio-3-transactions-concurrency/Screenshots) — Screenshots of the transaction results, the waiting state and the final concurrency outcome.

## References

- PostgreSQL Global Development Group. *Transactions*.
- PostgreSQL Global Development Group. *Transaction Isolation*.
- PostgreSQL Global Development Group. *Constraints*.