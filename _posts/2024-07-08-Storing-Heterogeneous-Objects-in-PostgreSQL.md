---
layout: post
lang: en
permalink: blog/Storing-Heterogeneous-Objects-in-PostgreSQL
title: Storing Heterogeneous Objects in PostgreSQL
categories:
  - development
tags:
  - java
  - sql
sharing:
  twitter: Storing Heterogeneous Objects in PostgreSQL
---

Storing different types of objects in a PostgreSQL database can be tricky. But don't worry, it's manageable. Let's explore three practical ways to handle this. We will keep it simple and straightforward.

## Scenario: Restaurant Order System

Imagine we have a Transaction table that stores different types of orders. Each order type has some common fields, but also unique fields.

### Using JSONB for Orders

The JSONB data type is flexible. It allows you to store various order types without much hassle.

#### JSONB Schema

```sql
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    orders JSONB
);
```

#### Inserting Data

You can insert data by converting orders to JSON.

```sql
INSERT INTO transactions (orders) VALUES (
    '[
        {"type": "HamburgerOrder", "field1": "value1", "field2": "value2"},
        {"type": "PizzaOrder", "field1": "value1", "field2": "value2", "uniqueField": "uniqueValue"}
    ]'::jsonb
);
```

#### Querying Data

Retrieving specific orders is easy.

```sql
SELECT * FROM transactions
WHERE orders @> '[{"type": "HamburgerOrder"}]';
```

#### Pros and Cons

Pros: Very flexible. Simple schema.
Cons: Complex queries. Limited data validation.

### Using a Normalized Schema

This method involves multiple tables and foreign keys. It keeps the database structure clean and efficient.

#### Schema

Transactions Table:

```sql
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY
);
```

Orders Table:

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    transaction_id INT REFERENCES transactions(id),
    type VARCHAR(50) NOT NULL,
    common_field1 TEXT,
    common_field2 TEXT
);
```

HamburgerOrder Table:

```sql
CREATE TABLE hamburger_orders (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    unique_hamburger_field TEXT
);
```

PizzaOrder Table:

```sql
CREATE TABLE pizza_orders (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id),
    unique_pizza_field TEXT
);
```

#### Inserting Data

Insert data step-by-step.

```sql
INSERT INTO transactions DEFAULT VALUES RETURNING id;

INSERT INTO orders (transaction_id, type, common_field1, common_field2) VALUES
(1, 'HamburgerOrder', 'value1', 'value2') RETURNING id;

INSERT INTO hamburger_orders (order_id, unique_hamburger_field) VALUES
(1, 'hamburgerValue');
```

#### Querying Data

Use JOIN queries to get all orders.

```sql
SELECT o.id AS order_id, o.type, o.common_field1, o.common_field2,
       h.unique_hamburger_field, p.unique_pizza_field
FROM orders o
LEFT JOIN hamburger_orders h ON o.id = h.order_id
LEFT JOIN pizza_orders p ON o.id = p.order_id
WHERE o.transaction_id = 1;
```

#### Pros and Cons
Pros: Strong data integrity. Efficient querying.
Cons: More complex schema. Requires more tables.

### Hybrid Approach: Common Fields + JSONB

This approach combines the best of both worlds. Common fields are stored directly in columns. Unique fields go into a JSONB column.

#### Schema

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    transaction_id INT REFERENCES transactions(id),
    type VARCHAR(50) NOT NULL,
    common_field1 TEXT,
    common_field2 TEXT,
    specific_fields JSONB
);
```

#### Inserting Data

Insert data with common fields and JSONB.

```sql
INSERT INTO orders (transaction_id, type, common_field1, common_field2, specific_fields) VALUES
(1, 'HamburgerOrder', 'value1', 'value2', '{"unique_hamburger_field": "hamburgerValue"}'::jsonb),
(1, 'PizzaOrder', 'value1', 'value2', '{"unique_pizza_field": "pizzaValue"}'::jsonb);
```

#### Querying Data

Query directly from the orders table.

```sql
SELECT * FROM orders WHERE transaction_id = 1;
```

#### Pros and Cons

Pros: Flexibility with JSONB. Easier querying for common fields.
Cons: Validation can be tricky. Slightly more complex.

## Conclusion

Choosing the right method depends on your needs. JSONB is flexible but validation can be tricky. A normalized schema ensures data integrity but requires more tables. The hybrid approach offers a balanced solution. Each method has its pros and cons. Pick the one that fits your project best. Happy coding!
