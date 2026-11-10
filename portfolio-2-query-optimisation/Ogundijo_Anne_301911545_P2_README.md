# Real Estate & Property Management — SQL queries

## 1. Show related leases, properties, tenants records (up to 20).

```sql
SELECT t0."lease_id" AS "leases_lease_id",
       t0."start_date" AS "leases_start_date",
       t1."property_id" AS "properties_property_id",
       t1."address" AS "properties_address",
       t2."tenant_id" AS "tenants_tenant_id",
       t2."full_name" AS "tenants_full_name"
FROM portfolio."leases" t0
JOIN portfolio."properties" t1 ON t0."property_id" = t1."property_id"
JOIN portfolio."tenants" t2 ON t0."tenant_id" = t2."tenant_id"
ORDER BY t0."lease_id", t1."property_id", t2."tenant_id"
LIMIT 20;
```

| leases_lease_id | leases_start_date | properties_property_id | properties_address | tenants_tenant_id | tenants_full_name |
| --- | --- | --- | --- | --- | --- |
| 301 | 2026-01-01 | 101 | 12 Cedar Lane | 201 | Alex Morgan |

## 2. Find properties records where address matches "12 Cedar Lane" (up to 20).

```sql
SELECT * FROM portfolio."properties"
WHERE "address" IS NOT DISTINCT FROM '12 Cedar Lane'
ORDER BY "property_id"
LIMIT 20;
```

| property_id | address | city | monthly_rent | bedrooms |
| --- | --- | --- | --- | --- |
| 101 | 12 Cedar Lane | Springfield | 1800 | 2 |

## 3. Count payments records for each lease_id (up to 20 groups).

```sql
SELECT "lease_id", count(*) AS record_count
FROM portfolio."payments"
GROUP BY "lease_id"
ORDER BY record_count DESC, "lease_id" NULLS LAST
LIMIT 20;
```

| lease_id | record_count |
| --- | --- |
| 301 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.93 | 0.92, 0.945, 0.93 | Sort → Seq Scan | 112 |
| After index | 0.166 | 0.166, 0.161, 0.167 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.93 ms to 0.166 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.872..0.873 rows=20 loops=1)
  Seq Scan on payments (actual time=0.019..0.838 rows=20 loops=1)
Planning Time: 0.347 ms
Execution Time: 0.92 ms
```

### Before index, run 2

```text
Sort (actual time=0.916..0.918 rows=20 loops=1)
  Seq Scan on payments (actual time=0.018..0.884 rows=20 loops=1)
Planning Time: 0.352 ms
Execution Time: 0.945 ms
```

### Before index, run 3

```text
Sort (actual time=0.902..0.903 rows=20 loops=1)
  Seq Scan on payments (actual time=0.016..0.868 rows=20 loops=1)
Planning Time: 0.327 ms
Execution Time: 0.93 ms
```

### After index, run 1

```text
Sort (actual time=0.118..0.12 rows=20 loops=1)
  Bitmap Heap Scan on payments (actual time=0.027..0.084 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.011..0.011 rows=20 loops=1)
Planning Time: 0.629 ms
Execution Time: 0.166 ms
```

### After index, run 2

```text
Sort (actual time=0.118..0.119 rows=20 loops=1)
  Bitmap Heap Scan on payments (actual time=0.027..0.085 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.011..0.011 rows=20 loops=1)
Planning Time: 0.557 ms
Execution Time: 0.161 ms
```

### After index, run 3

```text
Sort (actual time=0.122..0.123 rows=20 loops=1)
  Bitmap Heap Scan on payments (actual time=0.028..0.088 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.012 rows=20 loops=1)
Planning Time: 0.565 ms
Execution Time: 0.167 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Ogundijo_Anne_301911545_P2_Queries.sql, then Ogundijo_Anne_301911545_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Ogundijo_Anne_301911545_P2_QueryResults.png) · [Index comparison](screenshots/Ogundijo_Anne_301911545_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

