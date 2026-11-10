-- Show related leases, properties, tenants records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find properties records where address matches "12 Cedar Lane" (up to 20).
SELECT * FROM portfolio."properties"
WHERE "address" IS NOT DISTINCT FROM '12 Cedar Lane'
ORDER BY "property_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."properties"
WHERE "address" IS NOT DISTINCT FROM '12 Cedar Lane'
ORDER BY "property_id"
LIMIT 20;

-- Count payments records for each lease_id (up to 20 groups).
SELECT "lease_id", count(*) AS record_count
FROM portfolio."payments"
GROUP BY "lease_id"
ORDER BY record_count DESC, "lease_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "lease_id", count(*) AS record_count
FROM portfolio."payments"
GROUP BY "lease_id"
ORDER BY record_count DESC, "lease_id" NULLS LAST
LIMIT 20;
