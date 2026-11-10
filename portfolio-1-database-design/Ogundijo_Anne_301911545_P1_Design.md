# Real Estate & Property Management — database design

My case study records properties, tenants, leases, payments.

## Users

- Property managers
- Leasing staff
- Finance staff

## Main operations

- Record properties and tenant contact details.
- Create and manage leases for properties.
- Record payments and review rental activity.
- Compare a B-tree payment-date range-filter plan with a full scan using 20,000 synthetic payment rows.

## Entities

| Entity | Information stored |
| --- | --- |
| properties | Rental units managed by the organization. |
| tenants | People who rent managed properties. |
| leases | Agreements linking a tenant to a property for a defined period. |
| payments | Payments received for leases. |

## properties

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| property_id | BIGINT | PK | Yes |
| address | TEXT |  | Yes |
| city | TEXT |  | Yes |
| monthly_rent | NUMERIC(18,2) |  | Yes |
| bedrooms | INTEGER |  | Yes |


## tenants

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| tenant_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| phone | TEXT |  | No |
- Unique key: (email).

## leases

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| lease_id | BIGINT | PK | Yes |
| property_id | BIGINT | FK | Yes |
| tenant_id | BIGINT | FK | Yes |
| start_date | DATE |  | Yes |
| end_date | DATE |  | Yes |
| monthly_rent | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
- property_id → properties.property_id
- tenant_id → tenants.tenant_id

## payments

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| lease_id | BIGINT | FK | Yes |
| payment_date | DATE |  | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| payment_method | TEXT |  | No |
- lease_id → leases.lease_id

## Relationships and business rules

- A property's monthly rent must be greater than zero.
- A lease end date must be later than its start date.
- At most one lease with active status may reference a property; enforce this with a partial unique rule on property_id for active leases.
- Each lease property_id must reference properties.property_id.
- Each lease tenant_id must reference tenants.tenant_id.
- A recorded payment amount must be greater than zero.
- Each payment lease_id must reference leases.lease_id.

## Assumptions

- All records and benchmark data are synthetic; amounts are in USD.
- Each table has a single-column primary key whose values come from one globally unique identifier namespace.
- For a simple normalization example, start with Lease, which references Property and Tenant. Keep property attributes with Property and tenant attributes with Tenant rather than repeating them in Lease.
- A property may have at most one active lease at a time; historical leases remain stored.
- The distributed section is a discussion proposal only, not a running replica set.

