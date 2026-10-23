# Portfolio 5 Distributed and Cloud Database Exercise

## Current setup

The Ride-hailing and Logistics System uses **PostgreSQL 16** for its relational database and **MongoDB 8.0.34** in an Ubuntu Codespace. The MongoDB server uses `127.0.0.1:27017`, with its data stored in `/workspaces/mongodb-data`, outside the repository. Port forwarding is off. The MongoDB connection and ping checks succeeded according to the setup notes.

Portfolio 4 uses the `ride_logistics_p4` database and the `activity_events` collection, containing four example activity documents. The current MongoDB topology is not verified as a replica set, and no replication, failover or cloud deployment test has been documented.

## Proposed replication

I propose a three-member MongoDB replica set, with each voting member holding data on a separate host and in a separate failure zone. One member starts as primary and two as secondaries. These are starting roles; an election can change them. MongoDB replica sets replicate data and support high availability (MongoDB Replication).

| Member | Starting role | Location |
|--------|---------------|----------|
| Member 1 | Primary | Host A, failure zone A |
| Member 2 | Secondary | Host B, failure zone B |
| Member 3 | Secondary | Host C, failure zone C |

For example, a `trip_completed` event recording booking `P4-BKG-001` and its fare would be written to the primary and replicated to the secondary members. This is a proposed design, not an implemented deployment.

## Failure and consistency

If the primary fails, the remaining reachable voting members can elect an eligible secondary as the new primary. Writes may be interrupted during the election. With three voting members, a majority is two. If no majority can communicate, the replica set cannot elect a primary, so normal primary-based writes cannot continue. See *Replica Set Elections*.

Using write concern `{ w: "majority" }` requests acknowledgement after the calculated majority of data-bearing voting members has durably written the change to its local operation log. This improves durability, but secondaries may briefly lag while applying changes. See *Write Concern*.

Booking assignments, driver availability and fare validation must still follow the authoritative database's business rules. MongoDB replication does not replicate PostgreSQL data or automatically synchronise the two databases.

## Sharding and cloud deployment

Replication copies data across members; sharding distributes different portions of a dataset across shards to support larger workloads. The four-document Portfolio 4 example does not need sharding. An unsharded deployment is sufficient for its current size (MongoDB Sharding).

MongoDB Atlas could provide a managed cloud deployment. A production setup should use authentication, encryption in transit and at rest, restricted network and database access, and regular backups with tested restoration procedures. Costs depend on cluster capacity, availability requirements, storage, data transfer and backup options. Atlas backup and restore capabilities are described in the official documentation.

A limitation is that replication is not a substitute for independent backups, and a replica set alone does not guarantee application-level business-rule consistency. The proposed deployment has not been implemented or tested..