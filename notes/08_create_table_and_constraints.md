# 08 – CREATE TABLE and Constraints

> Source: SQL2 slides + your practice scripts. Runnable demo: [`scripts/mysql/01_constraints_demo.sql`](../scripts/mysql/01_constraints_demo.sql).
> The demo uses `INT`, `VARCHAR`, `DECIMAL` so it works in both MySQL and Oracle.

## 1. CREATE TABLE

**What:** creates a new table (a DDL statement).
**Why:** you must define the structure before you can store data.

```sql
CREATE TABLE table_name (
    column1  datatype  [DEFAULT value]  [column_constraint],
    column2  datatype  ...,
    [table_constraint, ...]
);
```

Example:

```sql
CREATE TABLE departments (
    department_id   INT,
    department_name VARCHAR(30) NOT NULL,
    location        VARCHAR(30),
    CONSTRAINT dept_id_pk PRIMARY KEY (department_id)
);
```

## 2. What is a constraint?

A **constraint** is a rule the database enforces on a table. If an INSERT, UPDATE or DELETE would break the rule, the database **rejects it**.

**Why:** the rule lives in the database, so no application, script or person can sneak in bad data. This is how the three integrity rules from note 04 are implemented.

| Constraint | Rule | Integrity type |
|---|---|---|
| `NOT NULL` | Column cannot be empty | Domain |
| `UNIQUE` | No duplicate values (NULL allowed) | Entity |
| `PRIMARY KEY` | Unique **and** not NULL. One per table | Entity |
| `FOREIGN KEY` | Value must exist in the parent table (or be NULL) | Referential |
| `CHECK` | Value must satisfy a condition | Domain |
| `DEFAULT` | Value used when none is given (strictly a column default, not a constraint) | Domain |

## 3. Two places to write a constraint

| Level | Where | Good for |
|---|---|---|
| **Column level** | Next to the column | Rules about a single column |
| **Table level** | At the end of `CREATE TABLE` | Rules about **several columns** (composite keys). Required for composite PK, UNIQUE, FK |

```sql
-- column level
email VARCHAR(25) CONSTRAINT emp_email_uk UNIQUE,
-- table level
CONSTRAINT emp_email_uk UNIQUE (email)
```
`NOT NULL` can **only** be written at column level.

**Always name your constraints** (`CONSTRAINT name ...`). If you don't, the database invents a name (Oracle: `SYS_C00123`), and error messages become hard to read. A common naming pattern is `table_column_type`, such as `emp_email_uk` (uk = unique, pk, fk, ck = check, nn = not null).

## 4. The full example

```sql
CREATE TABLE employees (
    employee_id   INT,
    last_name     VARCHAR(25) NOT NULL,
    email         VARCHAR(25),
    salary        DECIMAL(8,2),
    hire_date     DATE NOT NULL,
    department_id INT,
    CONSTRAINT emp_id_pk     PRIMARY KEY (employee_id),
    CONSTRAINT emp_email_uk  UNIQUE (email),
    CONSTRAINT emp_salary_ck CHECK (salary > 0),
    CONSTRAINT emp_dept_fk   FOREIGN KEY (department_id)
                             REFERENCES departments (department_id)
);
```
Create `departments` first. A foreign key needs the parent table to exist.

## 5. Each constraint in detail

### NOT NULL
Column must always have a value. A column without it can hold NULL.

### UNIQUE
No two rows can share the same value. **NULLs are allowed**, and many rows can have NULL because NULL is not equal to anything.
A **composite UNIQUE** covers a combination of columns:

```sql
CONSTRAINT dept_dname_loc_unq UNIQUE (dname, loc)
```
Here `('SALES','CHICAGO')` can appear once, but `'SALES'` can appear again with a different `loc`.
**Oracle only:** if part of a composite key is NULL, two rows with the same non-NULL part are still rejected. MySQL accepts them.
Your practice file: [`scripts/oracle/02_dept_unique_constraint.sql`](../scripts/oracle/02_dept_unique_constraint.sql)

### PRIMARY KEY
UNIQUE + NOT NULL, only one per table. Composite PK is written at table level: `PRIMARY KEY (student_id, course_id)`. The database automatically creates an index on it.
MySQL ignores the name you give a primary key (it is always called `PRIMARY`).

### FOREIGN KEY
```sql
CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments (department_id)
```
- `FOREIGN KEY (...)` = the column in the **child** table
- `REFERENCES parent (column)` = the **parent** table and column (must be PK or UNIQUE)
- A table can have **several** foreign keys, one per parent: [`scripts/oracle/03_multiple_foreign_keys.sql`](../scripts/oracle/03_multiple_foreign_keys.sql)
- Each constraint needs its **own unique name**. Two constraints both named `FK_table1` is an error.
- No trailing comma after the last constraint.

**Parent row deleted: what happens to children?**

```sql
FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id) ON DELETE CASCADE   -- delete children too
FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id) ON DELETE SET NULL  -- set child FK to NULL
-- nothing written = RESTRICT: the delete is refused
```
`SET NULL` needs a **nullable** FK column. With `supplier_id INT NOT NULL` it cannot work (MySQL refuses to create such a table).
Oracle has no `ON DELETE RESTRICT` keyword. Refusing is simply its default. MySQL accepts `RESTRICT`.

### CHECK
```sql
salary   DECIMAL(8,2) CONSTRAINT emp_salary_ck CHECK (salary > 0),
deptno   INT          CHECK (deptno BETWEEN 10 AND 99),
dname    VARCHAR(14)  CHECK (dname = UPPER(dname)),
loc      VARCHAR(13)  CONSTRAINT check_loc CHECK (loc IN ('DALLAS','BOSTON','NEW YORK','CHICAGO'))
```
Oracle CHECK cannot use `SYSDATE`, `USER`, `ROWNUM`, `CURRVAL`/`NEXTVAL`, or a query on other rows.
**MySQL:** CHECK is enforced only from **8.0.16**. Older MySQL accepts the syntax and silently ignores it.

### DEFAULT
Value used when you do not supply one. From your practice file (Oracle):

```sql
CREATE TABLE hire_date (
    id        NUMBER(8),
    hire_date DATE DEFAULT SYSDATE
);

INSERT INTO hire_date VALUES (45, NULL);      -- hire_date = NULL  (explicit NULL beats the default)
INSERT INTO hire_date (id) VALUES (35);       -- hire_date = today (column left out)
INSERT INTO hire_date VALUES (25, DEFAULT);   -- hire_date = today (DEFAULT keyword)
```
**Lesson:** the default is used only when you *leave the column out* or write the word `DEFAULT`. Typing `NULL` stores a NULL.
MySQL version: `hire_date DATE DEFAULT (CURRENT_DATE)` (8.0.13+). See [`scripts/mysql/02_default_example.sql`](../scripts/mysql/02_default_example.sql).

## 6. See it fail (the best way to learn constraints)

```sql
INSERT INTO employees VALUES (1, 'Ford', 'f@x.com', 3000, DATE '2024-04-01', 10);  -- duplicate PK
INSERT INTO employees VALUES (4, NULL, 'x@x.com', 3000, DATE '2024-04-01', 10);    -- NOT NULL
INSERT INTO employees VALUES (4, 'Adams', 'a@x.com', -5, DATE '2024-04-01', 10);   -- CHECK
INSERT INTO employees VALUES (4, 'Adams', 'a@x.com', 3000, DATE '2024-04-01', 99); -- FK: no dept 99
DELETE FROM departments WHERE department_id = 10;                                  -- FK: still referenced
```
Every one is rejected with an error that names the broken constraint.

## 7. Real-world use

In data engineering, constraints are why a clean source database gives you trustworthy data to load into a warehouse or HDFS. Many big-data tools do not enforce all of them. Hive, for example, does not enforce primary and foreign keys, so you must validate such rules yourself in the pipeline.

## Check yourself

1. Can a table have two UNIQUE constraints? Two primary keys?
2. Why does `ON DELETE SET NULL` fail on a `NOT NULL` column?
3. `INSERT INTO hire_date VALUES (45, NULL);` with `DEFAULT SYSDATE`. What is stored in `hire_date`?
4. Which constraint type can only be written at column level?

<details><summary>Answers</summary>

1. Yes to several UNIQUE. No, only one primary key (but it can be composite).
2. Setting the column to NULL would violate NOT NULL.
3. NULL. An explicit NULL overrides the default.
4. `NOT NULL`.
</details>

---
Previous: [07](07_where_and_order_by.md) | Next: [09 – ALTER, DROP, TRUNCATE and the Data Dictionary](09_alter_drop_truncate_dictionary.md)
