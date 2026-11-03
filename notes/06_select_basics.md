# 06 – SELECT Basics

> Source: SQL1 slides. The slides use Oracle's HR sample tables (`employees`, `departments`). These notes use the **EMP / DEPT** tables from [`scripts/mysql/00_demobld_mysql.sql`](../scripts/mysql/00_demobld_mysql.sql), so you can run every example yourself.

## 0. Set up the practice data

Run the script once in MySQL, then:

```sql
SELECT * FROM dept;
```
```
deptno | dname      | loc
10     | ACCOUNTING | NEW YORK
20     | RESEARCH   | DALLAS
30     | SALES      | CHICAGO
40     | OPERATIONS | BOSTON
```

`EMP` has 14 employees with columns `empno, ename, job, mgr, hiredate, sal, comm, deptno`.

## 1. What can SELECT do?

`SELECT` reads data. It has three abilities:

| Ability | Meaning | Think of it as |
|---|---|---|
| **Projection** | Choose which **columns** | Vertical slice |
| **Selection** | Choose which **rows** | Horizontal slice |
| **Join** | Combine data from **several tables** | (later lesson) |

## 2. Basic syntax

```sql
SELECT  [DISTINCT] column | expression [alias], ...
FROM    table;
```

- `SELECT` says **what** columns. `FROM` says **which table**.
- **Keyword** = one SQL word (`SELECT`). **Clause** = a part of a statement (`SELECT ename, sal`). **Statement** = clauses together (`SELECT * FROM emp;`).

## 3. Select all columns / specific columns

```sql
SELECT * FROM dept;                  -- all columns, all rows
SELECT deptno, loc FROM dept;        -- only these columns
SELECT loc, deptno FROM dept;        -- columns appear in the order you write them
```

`*` is handy for exploring. In real projects, name the columns you need.

## 4. Rules for writing SQL

- Keywords and names are **not case sensitive** (`select` = `SELECT`)
- A statement can span several lines
- Do **not** abbreviate or split a keyword across lines
- Put each clause on its own line and indent for readability
- Habit: keywords in UPPERCASE, names in lowercase
- End the statement with a **semicolon** `;`

## 5. Arithmetic expressions

Operators: `+  -  *  /`. Use them with numbers (and dates) in the `SELECT` list.

```sql
SELECT ename, sal, sal + 300 AS new_sal
FROM   emp
WHERE  deptno = 10;
```
```
ename  | sal  | new_sal
CLARK  | 2450 | 2750
KING   | 5000 | 5300
MILLER | 1300 | 1600
```
The new column exists **only in the result**. The table is not changed.

### Precedence: `*` and `/` before `+` and `-`; same level goes left to right

```sql
SELECT ename, sal, 12 * sal + 100   AS a,     -- multiply first, then add
                   12 * (sal + 100) AS b      -- brackets force add first
FROM emp WHERE deptno = 10;
```
```
ename  | sal  | a     | b
CLARK  | 2450 | 29500 | 30600
KING   | 5000 | 60100 | 61200
MILLER | 1300 | 15700 | 16800
```
When unsure, use brackets.

## 6. NULL in arithmetic

Anything + NULL (or × NULL) is **NULL**.

```sql
SELECT ename, sal, comm, sal + comm AS total
FROM   emp
WHERE  deptno = 30;
```
```
ename  | sal  | comm | total
ALLEN  | 1600 | 300  | 1900
WARD   | 1250 | 500  | 1750
MARTIN | 1250 | 1400 | 2650
BLAKE  | 2850 | NULL | NULL      <- NULL, not 2850
TURNER | 1500 | 0    | 1500      <- 0 is a value, so this works
JAMES  | 950  | NULL | NULL
```
(Row order may differ on your machine, because there is no `ORDER BY`.)

## 7. Column aliases

An **alias** gives a column a new heading in the output.

```sql
SELECT ename AS name, sal * 12 AS annual_salary
FROM   emp
WHERE  deptno = 10;
```
```
name   | annual_salary
CLARK  | 29400
KING   | 60000
MILLER | 15600
```

- `AS` is optional (`sal * 12 annual_salary` also works)
- If the alias has **spaces or special characters**, quote it: Oracle `"Annual Salary"`, MySQL `` `Annual Salary` ``
- Oracle shows unquoted aliases in UPPERCASE
- You **can** use an alias in `ORDER BY`. You **cannot** use it in `WHERE` (see execution order in note 07)

## 8. Concatenation and literals

A **literal** is a fixed value (text, number, date) written in the SELECT list. It is repeated for every row. Text and dates go in **single quotes**.

```sql
-- MySQL
SELECT CONCAT(ename, ' is a ', job) AS employee_details
FROM   emp
WHERE  deptno = 10;
-- Oracle
SELECT ename || ' is a ' || job AS employee_details
FROM   emp
WHERE  deptno = 10;
```
```
employee_details
CLARK is a MANAGER
KING is a PRESIDENT
MILLER is a CLERK
```
**MySQL warning:** `||` means logical OR in MySQL by default, so `ename || job` does **not** join text. Use `CONCAT()`.

## 9. Removing duplicates with DISTINCT

By default SELECT returns **all** rows, including duplicates.

```sql
SELECT deptno FROM emp;            -- 14 rows, department numbers repeat
SELECT DISTINCT deptno FROM emp;   -- 3 rows: 10, 20, 30 (order may vary)
```

`DISTINCT` applies to the **whole combination** of selected columns:

```sql
SELECT DISTINCT deptno, job FROM emp;   -- 9 unique (deptno, job) pairs
```
(Department 40 has no employees, so it never appears.)

## 10. Where this is used

Every report, dashboard and data pipeline starts with a `SELECT`. In data engineering you write it to extract data from a source database, check data quality, and (later) in Hive and Spark SQL on big data.

## Check yourself

1. What does `SELECT ename, sal * 12 FROM emp;` do to the `emp` table?
2. Why is `sal + comm` NULL for BLAKE?
3. Which gives fewer rows: `SELECT job FROM emp` or `SELECT DISTINCT job FROM emp`?
4. Write a query that shows each employee's name and monthly salary plus 500, headed `bonus_sal`.

<details><summary>Answers</summary>

1. Nothing. The calculated column is shown in the result only.
2. BLAKE's `comm` is NULL, and any arithmetic with NULL gives NULL.
3. `DISTINCT job`, because duplicates are removed.
4. `SELECT ename, sal + 500 AS bonus_sal FROM emp;`
</details>

---
Previous: [05](05_sql_intro_and_datatypes.md) | Next: [07 – WHERE and ORDER BY](07_where_and_order_by.md)
