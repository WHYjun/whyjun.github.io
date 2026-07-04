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

Storing different types of objects in one PostgreSQL table is tricky. Each type shares a few fields and carries its own. There are three practical ways to handle it, and each one trades flexibility for structure in a different spot.

## Scenario: Restaurant Order System

Imagine a `transactions` table that stores different types of orders. Each order type has some common fields and some unique ones.

### Using JSONB for Orders

The `JSONB` type is flexible. It lets you store different order types in one column without committing to a fixed shape.

#### Schema

```sql
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    orders JSONB
);
```

#### Inserting Data

You insert data by writing the orders as JSON.

```sql
INSERT INTO transactions (orders) VALUES (
    '[
        {"type": "HamburgerOrder", "field1": "value1", "field2": "value2"},
        {"type": "PizzaOrder", "field1": "value1", "field2": "value2", "uniqueField": "uniqueValue"}
    ]'::jsonb
);
```

#### Querying Data

Retrieving specific orders stays simple.

```sql
SELECT * FROM transactions
WHERE orders @> '[{"type": "HamburgerOrder"}]';
```

#### Pros and Cons

* Pros: Very flexible. Simple schema.
* Cons: Complex queries. Limited data validation.

### Using a Normalized Schema

This method splits the data across several tables joined by foreign keys. It keeps the structure explicit and efficient.

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

Insert the rows step by step.

```sql
INSERT INTO transactions DEFAULT VALUES RETURNING id;

INSERT INTO orders (transaction_id, type, common_field1, common_field2) VALUES
(1, 'HamburgerOrder', 'value1', 'value2') RETURNING id;

INSERT INTO hamburger_orders (order_id, unique_hamburger_field) VALUES
(1, 'hamburgerValue');
```

#### Querying Data

Use `JOIN` queries to pull the orders back together.

```sql
SELECT o.id AS order_id, o.type, o.common_field1, o.common_field2,
       h.unique_hamburger_field, p.unique_pizza_field
FROM orders o
LEFT JOIN hamburger_orders h ON o.id = h.order_id
LEFT JOIN pizza_orders p ON o.id = p.order_id
WHERE o.transaction_id = 1;
```

#### Pros and Cons

* Pros: Strong data integrity. Efficient querying.
* Cons: More complex schema. Requires more tables.

### Hybrid Approach: Common Fields + JSONB

This approach mixes both. Common fields live in their own columns. Unique fields go into a `JSONB` column.

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

Insert the common fields as columns and the rest as JSON.

```sql
INSERT INTO orders (transaction_id, type, common_field1, common_field2, specific_fields) VALUES
(1, 'HamburgerOrder', 'value1', 'value2', '{"unique_hamburger_field": "hamburgerValue"}'::jsonb),
(1, 'PizzaOrder', 'value1', 'value2', '{"unique_pizza_field": "pizzaValue"}'::jsonb);
```

#### Querying Data

Query the common fields straight from the columns.

```sql
SELECT * FROM orders WHERE transaction_id = 1;
```

#### Pros and Cons

* Pros: Flexibility with JSONB. Easier querying for common fields.
* Cons: Validation can be tricky. Slightly more complex.

## Conclusion

The right method depends on how strict your data has to be. `JSONB` is flexible but hard to validate. A normalized schema protects integrity but adds tables and joins. The hybrid keeps common fields queryable while leaving room for the odd ones. Pick the one that matches the shape of your data. Happy coding!
