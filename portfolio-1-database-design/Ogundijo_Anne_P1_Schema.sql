-- Real Estate & Property Management: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."properties" (
  "property_id" bigint NOT NULL,
  "address" text NOT NULL,
  "city" text NOT NULL,
  "monthly_rent" numeric(18,2) NOT NULL,
  "bedrooms" bigint NOT NULL,
  CONSTRAINT "pk_properties" PRIMARY KEY ("property_id")
);
CREATE TABLE portfolio."tenants" (
  "tenant_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "phone" text,
  CONSTRAINT "pk_tenants" PRIMARY KEY ("tenant_id"),
  CONSTRAINT "uq_tenants_0" UNIQUE ("email")
);
CREATE TABLE portfolio."leases" (
  "lease_id" bigint NOT NULL,
  "property_id" bigint NOT NULL,
  "tenant_id" bigint NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "monthly_rent" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_leases" PRIMARY KEY ("lease_id")
);
CREATE TABLE portfolio."payments" (
  "payment_id" bigint NOT NULL,
  "lease_id" bigint NOT NULL,
  "payment_date" date NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "payment_method" text,
  CONSTRAINT "pk_payments" PRIMARY KEY ("payment_id")
);
ALTER TABLE portfolio."leases" ADD CONSTRAINT "fk_leases_0" FOREIGN KEY ("property_id") REFERENCES portfolio."properties" ("property_id");
ALTER TABLE portfolio."leases" ADD CONSTRAINT "fk_leases_1" FOREIGN KEY ("tenant_id") REFERENCES portfolio."tenants" ("tenant_id");
ALTER TABLE portfolio."payments" ADD CONSTRAINT "fk_payments_0" FOREIGN KEY ("lease_id") REFERENCES portfolio."leases" ("lease_id");
ALTER TABLE portfolio."properties" ADD CONSTRAINT "property_rent_positive" CHECK ("monthly_rent" > 0);
ALTER TABLE portfolio."leases" ADD CONSTRAINT "lease_dates_ordered" CHECK ("end_date" > "start_date");
CREATE UNIQUE INDEX "one_active_lease_per_property" ON portfolio."leases" ("property_id") WHERE ("status" = 'active');
ALTER TABLE portfolio."payments" ADD CONSTRAINT "payment_amount_positive" CHECK ("amount" > 0);
COMMIT;
