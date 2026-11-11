-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. properties pk. Expected: pk_properties, SQLSTATE 23505.
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms")
VALUES (101, '13 Cedar Lane', 'Springfield', 1700, 2);

-- 2. properties property id null. Expected: property_id, SQLSTATE 23502.
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms")
VALUES (NULL, '14 Cedar Lane', 'Springfield', 1700, 2);

-- 3. properties address null. Expected: address, SQLSTATE 23502.
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms")
VALUES (1001, NULL, 'Springfield', 1700, 2);

-- 4. properties city null. Expected: city, SQLSTATE 23502.
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms")
VALUES (1002, '15 Cedar Lane', NULL, 1700, 2);

-- 5. properties rent null. Expected: monthly_rent, SQLSTATE 23502.
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms")
VALUES (1003, '16 Cedar Lane', 'Springfield', NULL, 2);

-- 6. properties bedrooms null. Expected: bedrooms, SQLSTATE 23502.
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms")
VALUES (1004, '17 Cedar Lane', 'Springfield', 1700, NULL);

-- 7. tenants pk. Expected: pk_tenants, SQLSTATE 23505.
INSERT INTO portfolio."tenants" ("tenant_id", "full_name", "email", "phone")
VALUES (201, 'Casey Lee', 'casey.lee@example.test', NULL);

-- 8. tenants unique email. Expected: uq_tenants_0, SQLSTATE 23505.
INSERT INTO portfolio."tenants" ("tenant_id", "full_name", "email", "phone")
VALUES (2001, 'Casey Lee', 'alex.morgan@example.test', '555-0101');

-- 9. tenants tenant id null. Expected: tenant_id, SQLSTATE 23502.
INSERT INTO portfolio."tenants" ("tenant_id", "full_name", "email", "phone")
VALUES (NULL, 'Jordan Lee', 'jordan.lee@example.test', NULL);

-- 10. tenants name null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."tenants" ("tenant_id", "full_name", "email", "phone")
VALUES (2002, NULL, 'taylor.lee@example.test', NULL);

-- 11. tenants email null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."tenants" ("tenant_id", "full_name", "email", "phone")
VALUES (2003, 'Riley Lee', NULL, NULL);

-- 12. leases pk. Expected: pk_leases, SQLSTATE 23505.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (301, 101, 201, '2027-01-01', '2027-12-31', 1800, 'inactive');

-- 13. leases property fk. Expected: fk_leases_0, SQLSTATE 23503.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3001, 99901, 201, '2027-01-01', '2027-12-31', 1800, 'inactive');

-- 14. leases tenant fk. Expected: fk_leases_1, SQLSTATE 23503.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3002, 101, 99902, '2027-01-01', '2027-12-31', 1800, 'inactive');

-- 15. leases lease id null. Expected: lease_id, SQLSTATE 23502.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (NULL, 101, 201, '2027-01-01', '2027-12-31', 1800, 'inactive');

-- 16. leases property id null. Expected: property_id, SQLSTATE 23502.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3003, NULL, 201, '2027-01-01', '2027-12-31', 1800, 'inactive');

-- 17. leases tenant id null. Expected: tenant_id, SQLSTATE 23502.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3004, 101, NULL, '2027-01-01', '2027-12-31', 1800, 'inactive');

-- 18. leases start date null. Expected: start_date, SQLSTATE 23502.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3005, 101, 201, NULL, '2027-12-31', 1800, 'inactive');

-- 19. leases end date null. Expected: end_date, SQLSTATE 23502.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3006, 101, 201, '2027-01-01', NULL, 1800, 'inactive');

-- 20. leases rent null. Expected: monthly_rent, SQLSTATE 23502.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3007, 101, 201, '2027-01-01', '2027-12-31', NULL, 'inactive');

-- 21. leases status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3008, 101, 201, '2027-01-01', '2027-12-31', 1800, NULL);

-- 22. payments pk. Expected: pk_payments, SQLSTATE 23505.
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method")
VALUES (401, 301, '2026-03-01', 1800, 'cash');

-- 23. payments lease fk. Expected: fk_payments_0, SQLSTATE 23503.
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method")
VALUES (4001, 99903, '2026-03-01', 1800, 'cash');

-- 24. payments payment id null. Expected: payment_id, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method")
VALUES (NULL, 301, '2026-03-01', 1800, NULL);

-- 25. payments lease id null. Expected: lease_id, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method")
VALUES (4002, NULL, '2026-03-01', 1800, NULL);

-- 26. payments date null. Expected: payment_date, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method")
VALUES (4003, 301, NULL, 1800, NULL);

-- 27. payments amount null. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method")
VALUES (4004, 301, '2026-03-01', NULL, NULL);

-- 28. property rent nonpositive. Expected: property_rent_positive, SQLSTATE 23514.
INSERT INTO portfolio."properties" ("property_id", "address", "city", "monthly_rent", "bedrooms")
VALUES (1005, '18 Cedar Lane', 'Springfield', 0, 2);

-- 29. lease dates not ordered. Expected: lease_dates_ordered, SQLSTATE 23514.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3009, 101, 201, '2027-01-01', '2027-01-01', 1800, 'inactive');

-- 30. lease active property duplicate. Expected: one_active_lease_per_property, SQLSTATE 23505.
INSERT INTO portfolio."leases" ("lease_id", "property_id", "tenant_id", "start_date", "end_date", "monthly_rent", "status")
VALUES (3010, 101, 201, '2027-01-01', '2027-12-31', 1800, 'active');

-- 31. payment amount nonpositive. Expected: payment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."payments" ("payment_id", "lease_id", "payment_date", "amount", "payment_method")
VALUES (4005, 301, '2026-03-01', 0, 'cash');
