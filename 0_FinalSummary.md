# MIT 8103 Advanced Database Systems: Portfolio Summary

**Case study:** Ride-hailing and Logistics System
**Name:** Fasanya Adeola
**Student ID:** 301930018
**Repository:** [https://github.com/Adeberyl/Fasanya_Adeola_301930018](https://github.com/Adeberyl/Fasanya_Adeola_301930018)

## Case study

The Ride-hailing and Logistics System manages customers, drivers, vehicles, bookings and trips for passenger transport and goods delivery. Its main operations include booking creation, driver assignment, trip-status updates and fare recording. The project explores relational database design, query optimisation, transaction management, document modelling and distributed database concepts. The implementation uses **PostgreSQL 16** and **MongoDB** in an Ubuntu Codespace.

## Portfolio 1: Database Design and Modelling

I designed a relational database with five tables: `customer`, `driver`, `vehicle`, `booking` and `trip`. The schema uses primary keys, foreign keys, unique constraints, required fields and CHECK constraints. The sample data contains **2 customers, 3 drivers, 3 vehicles, 5 bookings and 3 trips**.

The observed tests rejected a duplicate vehicle registration number, `LAG-123-AB`, through a unique-constraint error. A booking referencing the nonexistent customer ID `-999999` was also rejected through a foreign-key violation. These results demonstrate that the constraints protect data integrity. However, the schema does not fully enforce rules such as preventing overlapping trips or checking driver availability during assignment.

## Portfolio 2: Query Processing and Optimisation

I created a separate `p2_benchmark` schema containing **100,000 synthetic booking-history records**. I compared a date-range query before and after creating a B-tree index on `event_at` and `history_id`. Both executions returned **800 rows**, confirming that the query results remained consistent.

| Measurement | Before index | After index |
|---|---|---:|
| Scan method | Sequential Scan | Bitmap Index Scan and Bitmap Heap Scan |
| Execution time | 7.184 ms | 0.587 ms |
| Top-level shared buffer hits | 1,031 | 113 |
| Rows returned | 800 | 800 |

The observed execution time decreased by approximately **91.8%**, from 7.184 ms to 0.587 ms. Shared buffer hits also decreased. These are single observed runs, not averages or medians of repeated measurements. Cache state and system activity may affect timing, so the results indicate improvement in these runs rather than guaranteed performance under every workload. Indexes can also increase storage use and the cost of data modifications.

## Portfolio 3: Transactions and Concurrency

The portfolio investigates `COMMIT`, `ROLLBACK` and concurrency control in PostgreSQL. The proposed transaction exercise updates a booking from `assigned` to `in progress`, while the rollback exercise tests an invalid status against the existing CHECK constraint. A two-session test examines concurrent attempts to create trips for the same booking, relying on the unique constraint on `trip.booking_id`.

The documented transaction and concurrency outcomes are **expected behaviour, not verified test results**: the supplied portfolio notes do not include the actual session outputs or screenshots confirming these exercises. The design illustrates how transactions protect changes and how uniqueness can prevent duplicate trip records, but it does not prevent overlapping trips for a driver across different bookings.

## Portfolio 4: NoSQL and Advanced Data Models

I implemented a small MongoDB event model using **MongoDB 8.0.34** in my Ubuntu Codespace. The `ride_logistics_p4` database contains one collection, `activity_events`, with four fictional documents representing booking-status changes and trip completions. Embedded documents store booking, customer, driver and event-specific details.

Three queries produced the following observed results:

- **Total event count:** 4.
- **Ada's chronologically ordered event history:** 3 documents.
- **Completed-trip events with fares greater than ₦3,000:** 2 documents, with fares of ₦3,500 and ₦4,200.

These results demonstrate document counting, nested-field filtering and chronological retrieval. The documents were prepared separately rather than automatically imported from PostgreSQL. The example is suitable for demonstrating flexible event records, but it does not enforce all the system's booking and driver business rules.

## Portfolio 5: Distributed and Cloud Database Exercise

I documented the existing local MongoDB setup, including the connection address, data directory and successful connection checks. The actual topology has not been verified as a replica set.

I proposed a three-member replica set, with voting, data-bearing members on separate hosts and failure zones. The discussion explains primary elections, temporary write interruptions, majority write acknowledgement, secondary lag and the consequences of losing a voting majority. I also explained the difference between replication and sharding and why the four-document example does not need sharding.

The proposed distributed deployment and failover tests have **not been implemented or verified**. MongoDB replication would not automatically replicate or synchronise the separate PostgreSQL database. A production deployment would also require authentication, encryption, restricted access and tested backups and restoration.

## Evidence

The portfolio materials and supporting evidence are maintained in my GitHub repository:

- [MIT 8103 portfolio repository](https://github.com/Adeberyl/Fasanya_Adeola_301930018)
- [Portfolio 1 database design folder](https://github.com/Adeberyl/Fasanya_Adeola_301930018/tree/main/portfolio-1-database-design)

The repository is the main location for reviewing the SQL schema, sample data, constraint tests, query optimisation work, MongoDB example and portfolio documentation. Screenshots should be reviewed alongside the corresponding files to distinguish observed results from expected or proposed outcomes.

## Individual reflection

I chose the Ride-hailing and Logistics System because it allowed me to explore database design and implementation through a practical case. One difficulty was finding a server environment that could connect to my Git repository. I addressed this by using **GitHub Codespaces**.

This experience taught me that there are solutions to technical problems and that choosing a suitable development environment can help overcome implementation difficulties.

## References

- PostgreSQL Global Development Group. *PostgreSQL 16 Documentation: Indexes*. https://www.postgresql.org/docs/16/indexes.html
- PostgreSQL Global Development Group. *PostgreSQL 16 Documentation: EXPLAIN*. https://www.postgresql.org/docs/16/using-explain.html
- PostgreSQL Global Development Group. *Transactions*. https://www.postgresql.org/docs/16/tutorial-transactions.html
- PostgreSQL Global Development Group. *Transaction Isolation*. https://www.postgresql.org/docs/16/transaction-iso.html
- MongoDB. *Replication*. https://www.mongodb.com/docs/manual/replication/
- MongoDB. *Replica Set Elections*. https://www.mongodb.com/docs/v8.0/core/replica-set-elections/
- MongoDB. *Write Concern*. https://www.mongodb.com/docs/v8.0/reference/write-concern/
- MongoDB. *Sharding*. https://www.mongodb.com/docs/manual/sharding/
- MongoDB. *Atlas Backup and Restore*. https://www.mongodb.com/docs/atlas/backup-restore-cluster/
- MongoDB. *Install MongoDB on Ubuntu*. https://www.mongodb.com/docs/v8.0/tutorial/install-mongodb-on-ubuntu/

## AI-use declaration

I used Claude, ChatGPT and DeepSeek to assist with generating database queries and preparing Markdown content for README files. These tools supported the preparation and explanation of my portfolio work.

My stated verification focus was developing a deeper understanding of how databases work. AI assistance does not replace the need to check queries, execution results, constraints and technical explanations against the actual implementation. I remain responsible for the submitted work and for accurately distinguishing verified results from proposed designs.