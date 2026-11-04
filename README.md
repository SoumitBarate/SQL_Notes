# SQL_Notes

This repository contains a structured set of SQL notes for beginners, arranged as a progressive learning path. Readers are advised to begin with Note 01 and proceed in sequence. Each note explains **what** a concept is, **why** it is used, **how** it works and **where** it is applied, and includes a short, runnable example. Every note concludes with review questions for self-assessment.

> **Intended audience:** Engineering students and early-career professionals in data and data engineering who have no prior knowledge of databases.

## Reading Order

| # | Note | Topics Covered |
|---|---|---|
| 01 | [Database Basics](notes/01_database_basics.md) | Data, databases, DBMS, and the limitations of file-based storage |
| 02 | [Data Models and Schema](notes/02_data_models_and_schema.md) | Hierarchical, network and relational models; three-schema architecture; data independence |
| 03 | [RDBMS Concepts](notes/03_rdbms_concepts.md) | Tables, rows, columns, NULL values, Codd's 12 rules, storage structure, overview of MySQL |
| 04 | [Keys and Integrity](notes/04_keys_and_integrity.md) | Primary, foreign, candidate and composite keys; the three integrity rules |
| 05 | [SQL Introduction and Data Types](notes/05_sql_intro_and_datatypes.md) | DDL, DML, DCL and TCL; naming rules; data types; Oracle and MySQL comparison |
| 06 | [SELECT Basics](notes/06_select_basics.md) | Projection, expressions, NULL handling, aliases, concatenation, DISTINCT |
| 07 | [WHERE and ORDER BY](notes/07_where_and_order_by.md) | Filtering; LIKE, IN and BETWEEN; AND, OR and NOT; operator precedence; sorting |
| 08 | [CREATE TABLE and Constraints](notes/08_create_table_and_constraints.md) | NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT |
| 09 | [ALTER, DROP, TRUNCATE and the Data Dictionary](notes/09_alter_drop_truncate_dictionary.md) | Modifying table structures, removing data, querying metadata |

## Running the Examples

1. Install MySQL 8 (version 8.0.16 or later, which enforces `CHECK` constraints).
2. Load the practice tables:
   ```bash
   mysql -u <your-user> -p < scripts/mysql/00_demobld_mysql.sql
   ```
   This script creates a database named `sql_notes` containing the `EMP`, `DEPT`, `SALGRADE` and `BONUS` tables.
3. Work through the notes in order and execute the queries provided.

## Oracle and MySQL

The course slides use **Oracle** syntax, whereas the practice tables in this repository are written for **MySQL**. The core SQL language is common to both; each note therefore highlights the points at which the two systems differ, such as string concatenation, case sensitivity, and the syntax of ALTER and DROP. A summary of these differences is provided in [Note 05](notes/05_sql_intro_and_datatypes.md#6-oracle-vs-mysql-quick-differences-you-will-hit).

## Repository Layout

```
SQL_Notes/
├── README.md
├── notes/      notes, numbered in reading order
├── scripts/
│   ├── mysql/  practice tables, demonstrations and exercises for MySQL
│   └── oracle/ practice scripts for Oracle
└── slides/     original course slides (.ppt / .pptx)
```

## SQL in a Data Engineering Workflow

```
Source database (MySQL/Oracle)  ->  Ingestion  ->  Storage (HDFS / data lake)
        ->  Processing / query (Hive, Spark SQL)  ->  Analytics / reports
```

SQL is used at both ends of this workflow: to **extract** data from source databases and to **query** the processed data. Hive and Spark SQL use a dialect closely resembling standard SQL, with certain differences that will be covered in later notes.

## Roadmap (Planned Notes)

- INSERT, UPDATE, DELETE and transaction control (COMMIT / ROLLBACK)
- Single-row functions
- Joins
- GROUP BY and aggregate functions
- Window functions
- Subqueries
- Views and indexes
- SQL on big data platforms: Hive and Spark SQL

