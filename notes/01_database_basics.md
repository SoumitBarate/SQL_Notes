# 01 – Database Basics

> Source: Day1 slides. Read this first. No SQL yet, only the ideas behind it.

## 1. What is data, a database and a DBMS?

| Term | Simple meaning | Example |
|---|---|---|
| **Data** | A fact that can be recorded and has meaning | Name, phone number, city |
| **Database** | A collection of *logically related* data, built for a purpose | All students, courses and marks of a college |
| **DBMS** (Database Management System) | Software that lets you create, maintain and use a database | MySQL, Oracle, PostgreSQL, SQL Server |

A DBMS does three jobs:

| Job | Meaning | SQL you will meet later |
|---|---|---|
| **Define** | Create the structure: tables, data types, constraints, indexes | `CREATE TABLE` |
| **Construct** | Store the data on disk | `INSERT` |
| **Manipulate** | Query, add, change, delete data | `SELECT`, `UPDATE`, `DELETE` |

The DBMS keeps the description of the structure (table names, columns, types) in the **data dictionary** (also called **catalog** or **metadata**, meaning "data about data").

```
 Application / User  ->  DBMS (MySQL, Oracle ...)  ->  Database files on disk
                              |
                     Data dictionary (metadata)
```

## 2. Why do we need a DBMS? (the problem with plain files)

Before DBMS software, programs stored data in ordinary OS files. Problems:

| Problem | What it means |
|---|---|
| Hard to access data | Every new question needs a new program to be written |
| Redundancy and inconsistency | Same data stored in many files and the copies disagree |
| Concurrent updates conflict | Two users change the same file at the same time |
| No crash recovery | Power cut in the middle of an update leaves broken data |
| Weak security | Only OS passwords, nothing per-user or per-column |
| No integrity rules | Nothing stops invalid data being saved |

**Example:** a bank keeps a customer's address in a savings-account file and again in a loan file. The customer moves and only one file is updated. Now the bank has two different addresses for one person. A DBMS stores the address once.

## 3. Advantages and disadvantages of a DBMS

**Advantages**
- Data independence (change storage without breaking programs, see note 02)
- Efficient data access
- Data integrity and security
- Central administration
- Many users at once, and recovery after a crash
- Faster application development

**Disadvantages**
- Extra cost: software, hardware, training
- Overkill for very small or very simple applications, and for some real-time systems

## 4. Where are databases used?

Banking (all transactions), airlines (reservations, schedules), universities (registration, grades), sales (customers, products, orders), manufacturing (inventory, supply chain), HR (employees, salaries, tax).

## Check yourself

1. What is the difference between a database and a DBMS?
2. Give two problems of storing data in plain files.
3. What is metadata?

<details><summary>Answers</summary>

1. The database is the collected data. The DBMS is the software that manages it.
2. Any two of: redundancy/inconsistency, no crash recovery, concurrent-update conflicts, weak security, no integrity checks.
3. Data about data: the description of tables, columns and types, stored in the data dictionary.
</details>

---
Next: [02 – Data Models and Schema](02_data_models_and_schema.md)
