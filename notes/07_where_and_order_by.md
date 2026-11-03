# 07 – Restricting and Sorting Data: WHERE and ORDER BY

> Source: SQL1 slides. Examples use `EMP` / `DEPT` ([setup script](../scripts/mysql/00_demobld_mysql.sql)).

## 1. WHERE: choose rows

**What:** `WHERE` keeps only the rows that satisfy a condition (this is the *selection* ability from note 06).
**Where it goes:** right after `FROM`.

```sql
SELECT  ename, job, deptno
FROM    emp
WHERE   deptno = 10;
```

### Text and dates need single quotes. Numbers do not.

```sql
WHERE job = 'CLERK'        -- text: quotes
WHERE sal >= 2000          -- number: no quotes
```
- **Oracle:** text comparison is **case-sensitive**. `'clerk'` finds nothing, and the default date format is `DD-MON-RR`.
- **MySQL:** text comparison is usually **case-insensitive**, and dates are written `'YYYY-MM-DD'`.

## 2. Comparison operators

| Operator | Meaning |
|---|---|
| `=` | equal |
| `>` `>=` | greater than, greater or equal |
| `<` `<=` | less than, less or equal |
| `<>` (also `!=`) | not equal |

## 3. Other conditions

| Condition | Meaning |
|---|---|
| `BETWEEN a AND b` | in a range, **inclusive** of both ends (write the lower value first) |
| `IN (v1, v2, ...)` | equals any value in the list |
| `LIKE 'pattern'` | text pattern match |
| `IS NULL` / `IS NOT NULL` | is (not) a missing value |

### BETWEEN

```sql
SELECT ename, sal FROM emp WHERE sal BETWEEN 1250 AND 1600;
```
```
ALLEN 1600 | WARD 1250 | MARTIN 1250 | TURNER 1500 | MILLER 1300
```
Both 1250 and 1600 are included. `BETWEEN` is just a shorter way to write `sal >= 1250 AND sal <= 1600`.

### IN

```sql
SELECT ename, deptno FROM emp WHERE deptno IN (10, 30);
```
Returns the 9 employees of departments 10 and 30. `IN` is a shorter way to write `deptno = 10 OR deptno = 30`.

### LIKE and wildcards

| Symbol | Meaning |
|---|---|
| `%` | zero or more characters |
| `_` | exactly one character |

```sql
SELECT ename FROM emp WHERE ename LIKE 'S%';    -- starts with S   -> SMITH, SCOTT
SELECT ename FROM emp WHERE ename LIKE '_A%';   -- 2nd letter is A -> WARD, MARTIN, JAMES
```
To search for a real `%` or `_`, use `ESCAPE` (Oracle example from the slides):
`WHERE job_id LIKE '%SA\_%' ESCAPE '\'`.
(In MySQL `LIKE 'S%'` also matches `'smith'` because of case-insensitive comparison.)

### NULL: never use `= NULL`

NULL means "unknown", so it is not equal to anything, not even to another NULL.

```sql
SELECT ename, comm FROM emp WHERE comm = NULL;                   -- returns NO rows (wrong)
SELECT ename, comm FROM emp WHERE comm IS NULL AND deptno = 30;  -- BLAKE, JAMES
SELECT ename, comm FROM emp WHERE comm IS NOT NULL;              -- ALLEN, WARD, MARTIN, TURNER
```
TURNER's commission is `0`. That is a value, so `IS NULL` does **not** return him.

## 4. Logical operators: AND, OR, NOT

| Operator | Returns TRUE when |
|---|---|
| `AND` | **both** conditions are true |
| `OR` | **at least one** condition is true |
| `NOT` | the condition is **false** |

```sql
SELECT ename, job, sal FROM emp WHERE job = 'MANAGER' AND sal > 2800;   -- JONES, BLAKE
SELECT ename, job FROM emp WHERE job NOT IN ('CLERK', 'SALESMAN') AND deptno = 20;
-- JONES, SCOTT, FORD
```
`NOT` also works with `BETWEEN`, `LIKE`, `IN` and `IS NULL`:
`NOT BETWEEN`, `NOT LIKE`, `NOT IN`, `IS NOT NULL`.

## 5. Order of evaluation (precedence)

| Order | Operator |
|---|---|
| 1 | Arithmetic `* /` then `+ -` |
| 2 | Concatenation |
| 3 | Comparison `= > < <= >= <>` |
| 4 | `IS [NOT] NULL`, `LIKE`, `[NOT] IN` |
| 5 | `[NOT] BETWEEN` |
| 6 | `NOT` |
| 7 | `AND` |
| 8 | `OR` |

**The classic trap: `AND` runs before `OR`.**

```sql
-- Meaning: CLERK (any salary)  OR  (MANAGER with sal > 2500)
SELECT ename, job, sal FROM emp
WHERE  job = 'CLERK' OR job = 'MANAGER' AND sal > 2500;
```
```
SMITH CLERK 800 | JONES MANAGER 2975 | BLAKE MANAGER 2850
ADAMS CLERK 1100 | JAMES CLERK 950 | MILLER CLERK 1300
```
Brackets change the meaning:

```sql
-- Meaning: (CLERK or MANAGER)  AND  sal > 2500
SELECT ename, job, sal FROM emp
WHERE  (job = 'CLERK' OR job = 'MANAGER') AND sal > 2500;
```
```
JONES MANAGER 2975 | BLAKE MANAGER 2850
```
**Rule of thumb:** whenever you mix `AND` and `OR`, add brackets.

## 6. ORDER BY: sort the result

**Why:** without it, row order is **not guaranteed**, and may even differ between two runs of the same query.
**Where:** it is always the **last** clause.

```sql
SELECT ename, sal FROM emp ORDER BY sal;          -- ascending (default, ASC)
SELECT ename, sal FROM emp ORDER BY sal DESC;     -- descending
```

Default ascending order: numbers low→high, dates earliest→latest, text A→Z.
**NULLs:** Oracle puts them last in ascending order. MySQL puts them **first**.

### Sort by several columns

The order in the list is the order of importance.

```sql
SELECT ename, deptno, sal
FROM   emp
WHERE  job = 'CLERK'
ORDER BY deptno, sal DESC;     -- department ascending, then salary descending
```
```
ename  | deptno | sal
MILLER | 10     | 1300
ADAMS  | 20     | 1100
SMITH  | 20     | 800
JAMES  | 30     | 950
```
ADAMS comes before SMITH because within department 20 the salary is sorted **high to low**.

### Sort by alias or position

```sql
SELECT ename, sal * 12 AS annsal FROM emp WHERE deptno = 10 ORDER BY annsal;
-- MILLER 15600, CLARK 29400, KING 60000

SELECT ename, sal FROM emp ORDER BY 2 DESC;      -- 2 = second column in the SELECT list
```
You can also sort by a column that is **not** shown in the SELECT list.

## 7. How the database runs a query

You write `SELECT` first, but the database runs the clauses in this order:

```
1. FROM      -> which table
2. WHERE     -> filter rows
3. SELECT    -> pick/compute columns (aliases are created here)
4. ORDER BY  -> sort the result
```
This is why an alias is **not** usable in `WHERE` (it does not exist yet) but **is** usable in `ORDER BY`.

## Check yourself

1. Write a query for employees in department 30 earning at least 1500, highest salary first.
2. Why does `WHERE comm = NULL` return nothing?
3. What does `WHERE job = 'CLERK' OR job = 'MANAGER' AND sal > 2500` really mean?
4. Does `BETWEEN 10 AND 20` include 10 and 20?

<details><summary>Answers</summary>

1. `SELECT ename, sal FROM emp WHERE deptno = 30 AND sal >= 1500 ORDER BY sal DESC;`
2. NULL is never equal to anything. Use `IS NULL`.
3. `job = 'CLERK'` OR (`job = 'MANAGER'` AND `sal > 2500`), because AND runs first.
4. Yes. `BETWEEN` is inclusive on both ends.
</details>

---
Previous: [06](06_select_basics.md) | Next: [08 – CREATE TABLE and Constraints](08_create_table_and_constraints.md)
