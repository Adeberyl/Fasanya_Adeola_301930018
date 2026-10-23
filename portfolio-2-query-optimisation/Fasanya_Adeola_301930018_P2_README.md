# Portfolio 2 Query Processing and Optimisation

## Queries and results

The ride-hailing and logistics database uses PostgreSQL 16. A separate `p2_benchmark` schema contains a synthetic booking-history table, leaving the Portfolio 1 tables unchanged.

The setup generated **100,000 synthetic history records** using existing customer, booking and driver identifiers. The `ANALYZE` command refreshed the table statistics.

The date-range query retrieves history records from 1 March to 8 March 2025, inclusive of the start date and exclusive of 9 March.

| Check | Observed result |
|---|---:|
| Total synthetic history records | 100,000 |
| Rows returned before indexing | 800 |
| Rows returned after indexing | 800 |
| Rows removed by filter before indexing | 99,200 |

Both query executions returned the same 800 rows, showing that the index changed the access method without changing the query result.

## Index comparison

The B-tree index was created on `event_at` and `history_id` to support the date-range filter and ordering.

| Measurement | Before index | After index |
|---|---:|---:|
| Scan type | Sequential Scan | Bitmap Heap Scan with Bitmap Index Scan |
| Execution time observed | 7.184 ms | 0.587 ms |
| Median of three measured runs | Not available | Not available |
| Top-level shared buffer hits | 1,031 | 113 |

The buffer-hit values are from the supplied plans. The execution times are single observed runs, not averages or medians of three measurements.

## Performance analysis

Before indexing, PostgreSQL used a sequential scan to examine the table, removed 99,200 rows by filtering, and then sorted the 800 matching rows. After indexing, it used a bitmap index scan to locate matching date values and a bitmap heap scan to retrieve the corresponding records, followed by the same sort operation. The observed execution time decreased from 7.184 ms to 0.587 ms in the supplied runs, while top-level shared buffer hits decreased from 1,031 to 113. This is an encouraging result, but it is not a controlled three-run comparison: cache state, system activity and other runtime conditions can affect timings. The index also consumes storage and adds overhead to inserts, updates and deletes that affect indexed columns, so indexing should be based on query patterns and measured workload performance rather than assuming it always improves performance.

## Files

- [`BeforeIndex`](./BeforeIndex) — pre-index query plan and results.
- [`AfterIndex`](./AfterIndex) — post-index query plan and results.
- `p2_benchmark.booking_history_synthetic` — synthetic benchmark table.
- `idx_booking_history_synthetic_event_at_history_id` — B-tree index used for the comparison.

The file links assume `BeforeIndex` and `AfterIndex` are located in the repository root; adjust the relative paths if they are stored in another directory.

## Reference

- PostgreSQL Global Development Group. *PostgreSQL 16 Documentation: Indexes*. https://www.postgresql.org/docs/16/indexes.html
- PostgreSQL Global Development Group. *PostgreSQL 16 Documentation: EXPLAIN*. https://www.postgresql.org/docs/16/using-explain.html