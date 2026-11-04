# SQL_Notes

Plain-English SQL notes for beginners, written as a learning path. Start at note 01 and read in order. Every note explains **what** a thing is, **why** we use it, **how** it works, **where** it is used, and gives a small example you can run. Each note ends with a few questions to check yourself.

> **Who is this for?** Engineering students and anyone starting a career in data / data engineering who knows nothing about databases yet.

## Reading order

| # | Note | You will learn |
|---|---|---|
| 01 | [Database Basics](notes/01_database_basics.md) | Data, database, DBMS, why files are not enough |
| 02 | [Data Models and Schema](notes/02_data_models_and_schema.md) | Hierarchical, network, relational models; three-schema architecture; data independence |
| 03 | [RDBMS Concepts](notes/03_rdbms_concepts.md) | Tables, rows, columns, NULL, Codd's 12 rules, storage structure, MySQL overview |
| 04 | [Keys and Integrity](notes/04_keys_and_integrity.md) | Primary, foreign, candidate, composite keys; the three integrity rules |
| 05 | [SQL Introduction and Data Types](notes/05_sql_intro_and_datatypes.md) | DDL / DML / DCL / TCL, naming rules, data types, Oracle vs MySQL |
| 06 | [SELECT Basics](notes/06_select_basics.md) | Projection, expressions, NULL, aliases, concatenation, DISTINCT |
| 07 | [WHERE and ORDER BY](notes/07_where_and_order_by.md) | Filtering, LIKE / IN / BETWEEN, AND / OR / NOT, precedence, sorting |
| 08 | [CREATE TABLE and Constraints](notes/08_create_table_and_constraints.md) | NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT |
| 09 | [ALTER, DROP, TRUNCATE, Data Dictionary](notes/09_alter_drop_truncate_dictionary.md) | Changing tables, removing data, reading metadata |

## Try the examples yourself

1. Install MySQL 8 (8.0.16 or newer, so `CHECK` constraints are enforced).
2. Load the practice tables:
   ```bash
   mysql -u <your-user> -p < scripts/mysql/00_demobld_mysql.sql
   ```
   This creates a database `sql_notes` with `EMP`, `DEPT`, `SALGRADE` and `BONUS`.
3. Open the notes in order and run the queries.

## Oracle or MySQL?

The course slides use **Oracle** syntax. The practice tables here are for **MySQL**. The core of SQL is the same, so each note flags the places where the two differ (for example, joining text, case sensitivity, ALTER and DROP syntax). A summary table is in [note 05](notes/05_sql_intro_and_datatypes.md#6-oracle-vs-mysql-quick-differences-you-will-hit).

## Repository layout

```
SQL_Notes/
├── README.md
├── notes/      the notes, numbered in reading order
├── scripts/
│   ├── mysql/  practice tables and demos for MySQL
│   └── oracle/ practice scripts for Oracle
└── slides/     original course slides (.ppt / .pptx)
```

## Where SQL fits in a data engineering workflow

```
Source database (MySQL/Oracle)  ->  Ingestion  ->  Storage (HDFS / data lake)
        ->  Processing / query (Hive, Spark SQL)  ->  Analytics / reports
```
SQL is used at both ends: to **extract** from source databases and to **query** the processed data. Hive and Spark SQL use very similar SQL, with some differences you will learn later.

## Roadmap (planned notes)

- INSERT, UPDATE, DELETE and transactions (COMMIT / ROLLBACK)
- Single-row functions
- Joins
- GROUP BY and aggregate functions
- Subqueries
- Views and indexes
- SQL on big data: Hive and Spark SQL

## Sources

Course slides (Day1, SQL1, SQL2, Joins Exercise, Window Functions) and my own practice scripts, rewritten in my own words.
