# Real Estate & Property Management — ER diagram

```mermaid
erDiagram
    direction LR
    properties {
        bigint property_id PK
        text address
        text city
        numeric monthly_rent
        integer bedrooms
    }
    tenants {
        bigint tenant_id PK
        text full_name
        text email UK
        text phone "Optional"
    }
    leases {
        bigint lease_id PK
        bigint property_id FK
        bigint tenant_id FK
        date start_date
        date end_date
        numeric monthly_rent
        text status
    }
    payments {
        bigint payment_id PK
        bigint lease_id FK
        date payment_date
        numeric amount
        text payment_method "Optional"
    }
    properties ||--o{ leases : "property_id"
    tenants ||--o{ leases : "tenant_id"
    leases ||--o{ payments : "lease_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Ogundijo_Anne_301911545_ERDiagram.png)
