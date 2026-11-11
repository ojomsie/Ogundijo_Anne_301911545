# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection lease_events for lease_created and lease_activated events. These are fictional event examples based on leases, properties, tenants, payments.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related properties, tenants details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "lease_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "payments",
        "key": {
            "payment_id": 401
        },
        "snapshot": {
            "payment_id": 401,
            "lease_id": 301,
            "payment_date": "2026-02-01",
            "amount": 1800,
            "payment_method": "bank_transfer"
        }
    },
    "embedded": {
        "properties": [
            {
                "key": {
                    "property_id": 101
                },
                "snapshot": {
                    "property_id": 101,
                    "address": "12 Cedar Lane",
                    "city": "Springfield",
                    "monthly_rent": 1800,
                    "bedrooms": 2
                },
                "via": [
                    "payments.lease_id → leases.property_id → properties"
                ]
            }
        ],
        "tenants": [
            {
                "key": {
                    "tenant_id": 201
                },
                "snapshot": {
                    "tenant_id": 201,
                    "full_name": "Alex Morgan",
                    "email": "alex.morgan@example.test",
                    "phone": null
                },
                "via": [
                    "payments.lease_id → leases.tenant_id → tenants"
                ]
            }
        ]
    },
    "references": {
        "leases": [
            {
                "key": {
                    "lease_id": 301
                },
                "via": [
                    "payments.lease_id → leases"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("lease_events").find({"eventType":"lease_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "lease_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("lease_events").find({"source.key.payment_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "lease_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "lease_activated",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "payment_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("lease_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "lease_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "payment_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "lease_activated",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "payment_id": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("lease_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| lease_activated | 1 |
| lease_created | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Ogundijo_Anne_301911545_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Ogundijo_Anne_301911545_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

