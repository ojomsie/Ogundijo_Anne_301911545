-- Fictional sample records for Real Estate & Property Management.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms") VALUES (101, '12 Cedar Lane', 'Springfield', 1800, 2);
INSERT INTO portfolio."tenants" ("tenant_id", "full_name", "email", "phone") VALUES (201, 'Alex Morgan', 'alex.morgan@example.test', NULL);
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status") VALUES (301, 101, 201, '2026-01-01', '2026-12-31', 1800, 'active');
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method") VALUES (401, 301, '2026-02-01', 1800, 'bank_transfer');
COMMIT;
