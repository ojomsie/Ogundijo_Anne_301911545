// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("lease_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("lease_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "lease_created",
                    "lease_activated"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "payments"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "payment_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("lease_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "lease_activated",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "payments",
                    "key": {
                        "payment_id": 401
                    },
                    "field": "payment_method",
                    "value": "bank_transfer"
                }
            ],
            "examples": {
                "inspection_summary": "illustrative inspection_summary",
                "event_note": "illustrative event_note"
            }
        }
    }
]));
  await db.getCollection("lease_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("lease_events").find({"eventType":"lease_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("lease_events").find({"source.key.payment_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("lease_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("lease_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("lease_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("lease_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("lease_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
