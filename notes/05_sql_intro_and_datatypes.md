# 05 – SQL Introduction and Data Types

> Source: SQL2 slides. The slides use Oracle syntax. Where MySQL differs, it is marked **MySQL:**.

## 1. What is SQL?

**SQL (Structured Query Language)** is the standard language for working with relational databases.
**Why:** one language to create tables, add and read data, change data and control access.
**Where:** every relational database (MySQL, Oracle, PostgreSQL, SQL Server) and also SQL-on-big-data tools such as Hive and Spark SQL. The core ideas are the same, small details change.

What you can do with SQL: query data, insert, update, delete, create and alter tables, set permissions.

## 2. Types of SQL statements

| Category | Full name | Purpose | Statements |
|---|---|---|---|
| **DML** | Data Manipulation Language | Read and change **data** | `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `MERGE` |
| **DDL** | Data Definition Language | Create and change **structure** | `CREATE`, `ALTER`, `DROP`, `RENAME`, `TRUNCATE`, `COMMENT` |
| **DCL** | Data Control Language | **Permissions** | `GRANT`, `REVOKE` |
| **TCL** | Transaction Control Language | Save or undo work | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

(Many books put `SELECT` in its own group called DQL, "Data Query Language".)

## 3. Database objects

| Object | What it is |
|---|---|
| **Table** | Basic storage unit, made of rows and columns |
| **View** | A saved query that shows part of the data from one or more tables |
| **Index** | A lookup structure that makes some queries faster |

## 4. Naming rules for tables and columns

- Start with a **letter**
- Only letters, digits, `_`, `$`, `#` (avoid `$` and `#`)
- Not the same as another object you own
- Not a reserved word (`SELECT`, `TABLE`, `ORDER` ...)
- Length limit: MySQL 64 characters. Oracle traditionally 30 (longer in recent versions)
- Use meaningful names: `employee_salary`, not `x1`

## 5. Data types

A **data type** tells the database what kind of value a column holds and how much space it needs. Choosing the right type gives you correct sorting, correct maths and less storage.

### Text

| Type | Meaning | Example |
|---|---|---|
| `CHAR(n)` | **Fixed** length. Short values are padded with spaces | `CHAR(2)` for a state code |
| `VARCHAR(n)` (MySQL) / `VARCHAR2(n)` (Oracle) | **Variable** length, up to n | names, emails |
| `NCHAR`, `NVARCHAR2` | Unicode text (Oracle) | |
| `CLOB` / `TEXT` | Very large text | articles, logs |

Oracle limits: `CHAR` up to 2000 bytes, `VARCHAR2` up to 4000 bytes (32,767 if `MAX_STRING_SIZE=EXTENDED`).

### Numbers

| Type | Meaning |
|---|---|
| **MySQL integers**: `TINYINT`, `SMALLINT`, `INT`, `BIGINT` | Whole numbers, increasing size |
| `DECIMAL(p,s)` | **Exact** decimal. `p` = total digits, `s` = digits after the point. Use for money |
| `FLOAT`, `DOUBLE` | **Approximate** decimals. Fast but can round. Not for money |
| **Oracle:** `NUMBER(p,s)` | Covers integers and decimals. `p` up to 38 |

`DECIMAL(7,2)` or `NUMBER(7,2)` = up to 5 digits before the point and 2 after, so the largest value is 99999.99.
That is why the `EMP` table uses `SAL DECIMAL(7,2)`.

### Date and time

| MySQL | Oracle | Notes |
|---|---|---|
| `DATE` | `DATE` | **Oracle's DATE also stores the time** (to the second). MySQL's `DATE` is date only |
| `DATETIME`, `TIMESTAMP` | `TIMESTAMP(n)` | Date + time. Oracle default fractional seconds = 6 |
| `NOW()`, `CURDATE()` | `SYSDATE`, `CURRENT_DATE`, `SYSTIMESTAMP` | Current date/time |

Formatting a date as text:

```sql
-- Oracle
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM dual;
-- MySQL
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s');
```

### Binary and others

- Oracle: `RAW`, `BLOB`, `BFILE` (binary or large objects)
- MySQL: `BLOB`, `ENUM`, `SET`, `JSON`
- **Boolean:** MySQL has `BOOLEAN` (it is just `TINYINT(1)`). Oracle versions before 23ai have no `BOOLEAN` column type, people use `NUMBER(1)` or `CHAR(1)`.

## 6. Oracle vs MySQL: quick differences you will hit

| Topic | Oracle | MySQL |
|---|---|---|
| Join text | `a \|\| b` | `CONCAT(a, b)` (`\|\|` means OR by default) |
| Text comparison | Case-sensitive: `'Smith' = 'SMITH'` is false | Usually case-insensitive: `'Smith' = 'SMITH'` is true |
| `SELECT` without a table | Needs `FROM dual` | Not needed |
| NULLs in `ORDER BY ... ASC` | NULLs come **last** | NULLs come **first** |
| Empty string `''` | Treated as NULL | A real empty value |
| Alias with spaces | `"Annual Salary"` | `` `Annual Salary` `` |
| Limit rows | `FETCH FIRST n ROWS ONLY` | `LIMIT n` |
| Text type | `VARCHAR2` | `VARCHAR` |
| Date text format | `DD-MON-RR` display | `YYYY-MM-DD` |

## Check yourself

1. Which category is `TRUNCATE`? Which is `GRANT`?
2. Which type for a price like 1499.99: `FLOAT` or `DECIMAL(7,2)`? Why?
3. What is the difference between `CHAR(10)` and `VARCHAR(10)` when you store `'abc'`?

<details><summary>Answers</summary>

1. `TRUNCATE` is DDL. `GRANT` is DCL.
2. `DECIMAL(7,2)`. It is exact. `FLOAT` can introduce tiny rounding errors.
3. `CHAR(10)` stores `'abc'` padded with spaces to 10 characters. `VARCHAR(10)` stores just the 3 characters.
</details>

---
Previous: [04](04_keys_and_integrity.md) | Next: [06 – SELECT Basics](06_select_basics.md)
