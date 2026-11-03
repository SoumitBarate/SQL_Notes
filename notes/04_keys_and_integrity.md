# 04 – Keys and Data Integrity

> Source: Day1 and SQL2 slides.

## 1. Why keys?

In a table, you must be able to point at **exactly one row**. Keys make that possible, and they are also how tables are linked to each other.

## 2. Types of keys

Use this small table to follow the definitions:

```
STUDENT(student_id, email, phone, name)
```
Assume `student_id` and `email` are never repeated. `name` can repeat (two students called "Asha").

| Key | Definition | In the STUDENT table |
|---|---|---|
| **Super key** | Any set of columns that uniquely identifies a row (can contain extra columns) | `{student_id}`, `{email}`, `{student_id, name}`, `{email, phone}` ... |
| **Candidate key** | A *minimal* super key: remove any column and it stops being unique | `{student_id}`, `{email}` |
| **Primary key (PK)** | The candidate key you choose as the main identifier | `student_id` |
| **Alternate (secondary) key** | A candidate key that was *not* chosen as PK | `email` |
| **Composite key** | A key made of **two or more columns** | `ENROLLMENT(student_id, course_id)` |
| **Non-key attribute** | A column that is not part of any candidate key | `name`, `phone` |

Relationship: **Super keys ⊇ Candidate keys ⊇ Primary key**.

### Example from the slides (Schedule table)

```sql
CREATE TABLE schedule (
  teacher   CHAR(20)  NOT NULL,
  period    INT       NOT NULL CHECK (period BETWEEN 1 AND 6),
  classroom INT       NOT NULL,
  UNIQUE (teacher, period),            -- candidate key: a teacher is in one place per period
  UNIQUE (teacher, classroom),         -- candidate key
  UNIQUE (period, classroom),          -- candidate key: a room hosts one class per period
  UNIQUE (teacher, period, classroom)  -- super key: has a smaller unique key inside it
);
```
`(teacher, period, classroom)` is only a *super key* because it still contains smaller unique sets.

## 3. Primary key

**What:** a column (or columns) whose values identify each row.
**Rules:** no duplicates, **no NULL**, only **one PK per table**.
**Why:** guarantees uniqueness, gives fast lookup (the DBMS indexes it automatically), and lets other tables point to the row.

A good PK is **unique, never NULL, never changes (immutable)**.

**Why not use the Aadhaar number as a PK?**
- It is sensitive personal data. A PK gets copied into other tables, logs and reports, which spreads it widely.
- Real data has errors and duplicates through data entry, and a PK value should never need to be corrected.
- Not every person in your system will have one.

Better: a system-generated ID (`student_id`) and keep Aadhaar, if you must store it, as a normal protected column.

## 4. Foreign key

**What:** a column in one table that refers to the **primary key (or a unique key)** of another table.
**Why:** it links tables and stops invalid links.
**Parent / child:** the table being referred to is the **parent**. The table holding the foreign key is the **child**.

```
DEPT (parent)                 EMP (child)
deptno  dname                 empno  ename   deptno  <- foreign key
10      ACCOUNTING            7782   CLARK   10
20      RESEARCH              7369   SMITH   20
                              9999   NEWBIE  50     X rejected: no dept 50
```

Properties of a foreign key:
- It must match an existing parent value **or be NULL**
- The parent column must be a PRIMARY KEY or UNIQUE
- Duplicates are allowed in the child (many employees, one department)

**Relationship types:** one-to-one, one-to-many (the usual one: one department, many employees), many-to-many.
Many-to-many is built with a third **junction table** that has two foreign keys:

```
STUDENT (1) ────< ENROLLMENT >──── (1) COURSE
        ENROLLMENT(student_id, course_id)  <- composite PK, and each column is also an FK
```

**What happens when a parent row is deleted?**

| Option | Behaviour |
|---|---|
| Default (restrict) | Delete is **refused** while child rows exist |
| `ON DELETE CASCADE` | Child rows are **deleted too** |
| `ON DELETE SET NULL` | Child's FK column is set to **NULL** |

Advantages: no *orphan records* (children with no parent), consistent data, relationships enforced by the database itself instead of application code.

## 5. The three integrity rules

**Data integrity** = the data is accurate, consistent and reliable.

| Rule | Meaning | Enforced by |
|---|---|---|
| **Entity integrity** | Every row is uniquely identifiable | PRIMARY KEY (no duplicates, no NULL), UNIQUE (no duplicates, NULL allowed) |
| **Referential integrity** | Relationships between tables stay valid | FOREIGN KEY |
| **Domain integrity** | Values in a column are of the right type and within allowed values | Data type, size, `NOT NULL`, `CHECK`, `DEFAULT` |

PRIMARY KEY vs UNIQUE:

| | PRIMARY KEY | UNIQUE |
|---|---|---|
| Duplicates | No | No |
| NULL | **No** | Yes |
| How many per table | **One** | Many |

All of these are implemented in SQL as **constraints**. See [08 – Constraints](08_create_table_and_constraints.md).

## Check yourself

1. `STUDENT(student_id, email, name)`: `student_id` is the PK, and `email` is unique and never NULL. Which column is the alternate key?
2. Can a foreign key column contain NULL? Can a primary key column?
3. A row in `EMP` has `deptno = 50` but `DEPT` has no department 50. Which integrity rule is broken?

<details><summary>Answers</summary>

1. `email`. It is a candidate key that was not chosen as the primary key.
2. Foreign key: yes. Primary key: no.
3. Referential integrity.
</details>

---
Previous: [03](03_rdbms_concepts.md) | Next: [05 – SQL Introduction and Data Types](05_sql_intro_and_datatypes.md)
