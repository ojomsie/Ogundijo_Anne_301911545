# Real Estate & Property Management — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| property_id | leases records (list) |
| --- | --- |
| 101 | [301] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| leases.lease_id | leases.property_id | leases.tenant_id | leases.status | properties.property_id | properties.address | tenants.tenant_id | tenants.full_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | active | 101 | 12 Cedar Lane | 201 | Alex Morgan |

Key: lease_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## leases_example

| leases.lease_id | leases.property_id | leases.tenant_id | leases.status | properties.property_id | properties.address | tenants.tenant_id | tenants.full_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | active | 101 | 12 Cedar Lane | 201 | Alex Morgan |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## properties

| property_id | address | city | monthly_rent | bedrooms |
| --- | --- | --- | --- | --- |
| 101 | 12 Cedar Lane | Springfield | 1800 | 2 |

## tenants

| tenant_id | full_name | email | phone |
| --- | --- | --- | --- |
| 201 | Alex Morgan | alex.morgan@example.test | NULL |

## leases

| lease_id | property_id | tenant_id | start_date | end_date | monthly_rent | status |
| --- | --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026-01-01 | 2026-12-31 | 1800 | active |

## payments

| payment_id | lease_id | payment_date | amount | payment_method |
| --- | --- | --- | --- | --- |
| 401 | 301 | 2026-02-01 | 1800 | bank_transfer |

## Dependencies

- properties: (property_id) → address, city, monthly_rent, bedrooms
- tenants: (tenant_id) → full_name, email, phone
- leases: (lease_id) → property_id, tenant_id, start_date, end_date, monthly_rent, status
- payments: (payment_id) → lease_id, payment_date, amount, payment_method

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
