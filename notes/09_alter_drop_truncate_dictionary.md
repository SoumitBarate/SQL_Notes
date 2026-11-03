# 09 – ALTER, DROP, RENAME, TRUNCATE and the Data Dictionary

> Source: SQL2 slides. The slides use Oracle syntax. **MySQL:** differences are marked.
> All of these are **DDL** statements. DDL commits automatically, so you cannot `ROLLBACK` them.

## 1. ALTER TABLE: change a table's structure

**Why:** requirements change after the table is created and holds data.

### Add a column
```sql
ALTER TABLE dept80 ADD (job_id VARCHAR2(9));        -- Oracle
ALTER TABLE dept80 ADD COLUMN job_id VARCHAR(9);    -- MySQL
```
The new column goes at the **end**. Existing rows get NULL in it.

### Modify a column
```sql
ALTER TABLE dept80 MODIFY (last_name VARCHAR2(30)); -- Oracle
ALTER TABLE dept80 MODIFY last_name VARCHAR(30);    -- MySQL
```
Oracle rules from the slides:
- You can **increase** width or precision any time
- You can **decrease** width only if the column is empty or holds only NULLs (or the table has no rows)
- You can change the data type only if the column holds only NULLs
- A new default affects **only future inserts**

### Drop a column
```sql
ALTER TABLE dept80 DROP COLUMN job_id;
```
In Oracle this form drops one column at a time. At least one column must remain, and **a dropped column cannot be recovered**.

### Oracle only: SET UNUSED
```sql
ALTER TABLE dept80 SET UNUSED (last_name);    -- hides the column quickly
ALTER TABLE dept80 DROP UNUSED COLUMNS;       -- later: really removes it and frees space
```
Faster for big tables because the data is not rewritten immediately.

## 2. Add, drop, disable constraints

Adding works the same in both:

```sql
ALTER TABLE employees
ADD CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id);

ALTER TABLE ship_cont ADD PRIMARY KEY (ship_no, container_no);   -- composite primary key
```
A table can reference **itself** (employee → manager is also an employee).

Adding `NOT NULL`:
```sql
ALTER TABLE employees MODIFY (salary CONSTRAINT emp_salary_nn NOT NULL);   -- Oracle
ALTER TABLE employees MODIFY salary DECIMAL(8,2) NOT NULL;                 -- MySQL
```
It works only if no existing row has NULL in that column.

You can add or drop a constraint but **not edit** one. To change a rule, drop it and add it again.

| Action | Oracle | MySQL |
|---|---|---|
| Drop a named constraint | `ALTER TABLE t DROP CONSTRAINT name;` | PK: `DROP PRIMARY KEY` · FK: `DROP FOREIGN KEY name` · UNIQUE: `DROP INDEX name` · CHECK: `DROP CHECK name` |
| Drop PK and the FKs that use it | `ALTER TABLE t DROP PRIMARY KEY CASCADE;` | drop the FKs first |
| Disable / enable without dropping | `ALTER TABLE t DISABLE CONSTRAINT name [CASCADE];` `... ENABLE CONSTRAINT name;` | Not available per constraint. For FKs: `SET FOREIGN_KEY_CHECKS = 0;` (and `= 1;` afterwards) |
| Drop a column and the constraints on it | `ALTER TABLE t DROP COLUMN c CASCADE CONSTRAINTS;` | drop constraints first |

When you enable a constraint, **all existing rows must already satisfy it**.

## 3. DROP TABLE, RENAME, TRUNCATE

| Statement | What it does | Rollback? |
|---|---|---|
| `DROP TABLE t;` | Removes the table: **structure, data and indexes** | No |
| `TRUNCATE TABLE t;` | Removes **all rows**, keeps the structure. Fast | No |
| `DELETE FROM t [WHERE ...];` | Removes rows (all or some). A **DML** statement | **Yes**, before `COMMIT` (MySQL InnoDB: inside a transaction) |

```sql
DROP TABLE dept80;
DROP TABLE emp CASCADE CONSTRAINTS;    -- Oracle: also drops foreign keys of other tables that point to it
RENAME dept TO detail_dept;            -- Oracle (you must own the object)
RENAME TABLE dept TO detail_dept;      -- MySQL
TRUNCATE TABLE detail_dept;
```
Good to know:
- You **cannot truncate** a table that other tables reference with a foreign key. Disable the FK first (Oracle) or drop it.
- `TRUNCATE` is faster than `DELETE` because it generates no rollback information and does not fire delete triggers.
- **MySQL:** there is no `CASCADE CONSTRAINTS`. Drop the child tables first.
- **Oracle:** the slides call `DROP TABLE` irreversible. In Oracle 10g and later a dropped table normally goes to the recycle bin and can often be brought back with `FLASHBACK TABLE t TO BEFORE DROP;`, unless you wrote `DROP TABLE t PURGE;`. MySQL has no recycle bin. Do not rely on this.

## 4. The data dictionary: the database's own catalog

**What:** a set of read-only tables/views in which the database stores **metadata** about every object (note 01).
**Why:** to find out which tables, columns and constraints exist, without any documentation.

### Oracle: three families of views

| Prefix | Shows |
|---|---|
| `USER_*` | Objects **you own** |
| `ALL_*` | Objects you have **permission** to use |
| `DBA_*` | **Everything** in the database (DBA access needed) |

| View | Use |
|---|---|
| `USER_OBJECTS` | Every object (table, view, index ...): `object_name`, `object_type`, `created`, `last_ddl_time`, `status` |
| `USER_TABLES` | One row per table: `table_name`, `num_rows`, `blocks`, `avg_row_len`, `last_analyzed` |
| `USER_TAB_COLS` | One row per column: `table_name`, `column_name`, `data_type`, `data_length`, `nullable` |
| `USER_CONSTRAINTS` | Constraint names and types |
| `USER_CONS_COLUMNS` | Which columns each constraint covers |

`num_rows` is filled from optimizer statistics, so it can be empty or out of date until statistics are gathered (`last_analyzed` tells you when).

```sql
SELECT constraint_name, constraint_type, search_condition
FROM   user_constraints
WHERE  table_name = 'EMPLOYEES';      -- table names are stored in UPPERCASE

SELECT constraint_name, column_name
FROM   user_cons_columns
WHERE  table_name = 'EMPLOYEES';
```
`constraint_type` codes: **P** = primary key, **R** = foreign key (referential), **U** = unique, **C** = check. A `NOT NULL` is stored as type **C**.

### MySQL equivalents

```sql
SHOW TABLES;                          -- list tables
DESCRIBE employees;                   -- columns, types, NULL, key
SHOW CREATE TABLE employees;          -- full definition including constraints

SELECT constraint_name, constraint_type
FROM   information_schema.table_constraints
WHERE  table_schema = DATABASE() AND table_name = 'employees';

SELECT column_name, data_type, is_nullable
FROM   information_schema.columns
WHERE  table_schema = DATABASE() AND table_name = 'employees';
```
(Oracle's `DESCRIBE` shows `NOT NULL` only. To see the other constraints, query the views above.)

## 5. Practice (using your EMP and DEPT tables)

`DEPT` from the demo script has no key, and `EMP` has no foreign key. Add them:

```sql
ALTER TABLE dept ADD PRIMARY KEY (deptno);
ALTER TABLE emp  ADD CONSTRAINT emp_dept_fk FOREIGN KEY (deptno) REFERENCES dept (deptno);
```
Then try: insert an employee with `deptno = 99` (should fail), delete department 10 (should fail), then `DROP` the FK and retry. Check your work with `SHOW CREATE TABLE emp;`.

## Check yourself

1. Which can you roll back: `DELETE`, `TRUNCATE` or `DROP TABLE`?
2. You need to find all constraints on `EMPLOYEES` in Oracle. Which view?
3. What is the difference between `USER_TABLES` and `ALL_TABLES`?
4. Your column is `VARCHAR2(10)` and holds data. Can you shrink it to `VARCHAR2(5)`?

<details><summary>Answers</summary>

1. Only `DELETE` (before commit). `TRUNCATE` and `DROP` are DDL and commit automatically.
2. `USER_CONSTRAINTS` (and `USER_CONS_COLUMNS` for the columns).
3. `USER_TABLES` lists tables you own. `ALL_TABLES` lists every table you are allowed to access.
4. Only if the column is empty/NULL or the table has no rows. Otherwise Oracle refuses.
</details>

---
Previous: [08](08_create_table_and_constraints.md) | Back to [README](../README.md)
