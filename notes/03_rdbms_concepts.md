# 03 – RDBMS Concepts

> Source: Day1 and SQL2 slides.

## 1. What is an RDBMS?

A **Relational DBMS** stores data in **related tables**. A table is a collection of records (rows). All rows in a table have the same fields (columns). One database holds many tables, and tables are linked using keys (note 04).

```
 DB server
 ├── DEPT table  (deptno, dname, loc)
 └── EMP table   (empno, ename, sal, deptno ...)   <- deptno links back to DEPT
```

## 2. Terminology

| Formal term | Everyday term | Meaning |
|---|---|---|
| Relation | **Table** | Basic storage unit |
| Tuple | **Row / record** | All data about one thing (one employee) |
| Attribute | **Column** | One kind of data (salary) |
| Field | **Cell** | Intersection of a row and a column. Holds exactly one value |
| NULL | | A field with **no value** (unknown or not applicable). It is **not** 0 and **not** an empty string |

## 3. Properties of a relational table

1. Every value is **atomic** (one value per cell, no lists)
2. Every row is **unique**
3. All values in a column are of the **same kind**
4. Order of columns does not matter
5. Order of rows does not matter (use `ORDER BY` when you need an order)
6. Every column has a **unique name**

## 4. Codd's 12 rules (short version)

E. F. Codd listed 12 rules to judge how "relational" a DBMS is. In practice, no product follows all of them completely.

| # | Rule | In plain words |
|---|---|---|
| 1 | Information | All data is stored as values in tables, in one way only |
| 2 | Guaranteed access | Any value can be found using table name + primary key + column name |
| 3 | Systematic NULLs | NULL is supported for missing data and is different from 0 and blank |
| 4 | Dynamic catalog | The catalog is itself tables, queried with the same language |
| 5 | Comprehensive sublanguage | One language (SQL) to define, query and change data |
| 6 | View updating | Views (virtual tables) should be updatable |
| 7 | High-level insert/update/delete | Commands work on sets of rows, not one record at a time |
| 8 | Physical data independence | Storage changes do not break applications |
| 9 | Logical data independence | Table-structure changes do not break user views |
| 10 | Integrity independence | Constraints are stored in the catalog, not in application code |
| 11 | Distribution independence | Works the same if data is spread over several sites |
| 12 | Non-subversion | Low-level access cannot bypass the integrity rules |

## 5. Advantages and drawbacks of an RDBMS

| Advantages | Drawbacks |
|---|---|
| Data independence | One more layer between the program and stored data |
| Minimal duplication | Needs a powerful machine |
| Easy data sharing | Needs a lot of memory |
| Enforces integrity | |
| Security, backup and recovery | |

## 6. Storage structure (how the DBMS stores data on disk)

| Part | Meaning |
|---|---|
| **Tablespace** | Logical container that groups tables, indexes and views. Can spread over several files or disks |
| **Data file** | Physical file that holds the actual table and index data |
| **Control file** | Holds metadata such as data-file locations and log information. Read at startup to find the data files. *(An Oracle concept. MySQL has no control file.)* |

When you create a table, it is stored in a data file inside a tablespace. If space runs out, new data files are added.

## 7. MySQL in one look

- **Client/server**: many clients talk to one database server
- Runs on Windows, Linux, macOS
- Default network protocol: TCP/IP (also Unix sockets, named pipes on Windows)
- Follows many ANSI/ISO SQL standards
- Scaling features: **replication** (backup and load sharing), **clustering** (availability), **partitioning** (big tables)
- Security: SSL encryption, role-based access control, authentication plugins

## Check yourself

1. Is NULL the same as 0?
2. Why do we write `ORDER BY` if rows have no fixed order?
3. Which Codd rule says constraints must be stored in the catalog and not in the application?

<details><summary>Answers</summary>

1. No. 0 is a value. NULL means no value or unknown.
2. A table does not guarantee any row order. `ORDER BY` is the only way to get a reliable order.
3. Rule 10, Integrity independence.
</details>

---
Previous: [02](02_data_models_and_schema.md) | Next: [04 – Keys and Integrity](04_keys_and_integrity.md)
