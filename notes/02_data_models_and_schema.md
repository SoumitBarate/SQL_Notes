# 02 – Data Models and Schema

> Source: Day1 slides.

## 1. What is a data model?

A **data model** is a set of concepts used to describe the *structure* of a database: data types, relationships and constraints. Three levels:

| Level | Describes | Example concepts |
|---|---|---|
| **High-level (conceptual)** | The database the way users think about it | Entity, attribute, relationship |
| **Representational (implementation)** | The concepts turned into a concrete structure | Tables, trees, networks, objects |
| **Low-level (physical)** | How data is stored on disk | Files, blocks, indexes |

## 2. Representational models (history, oldest first)

| Model | Structure | Example products |
|---|---|---|
| **Hierarchical** (1960s) | Tree. Every record has exactly **one parent** | IBM IMS |
| **Network** (1960s) | Records linked in a graph. A record can have **many parents** | GE IDS |
| **Relational** (1970s) | **Tables** and keys | Oracle, MySQL, DB2, SQL Server |
| **Object** | Objects from object-oriented programs stored directly | ObjectStore |
| **Object-relational** | Objects stored inside tables | Oracle, Informix |

**Why the old models lost**
- *Hierarchical:* lots of duplicated data, changes are complex, hard to query, child records mean little without the parent.
- *Network:* very complex, errors are hard to trace, any structure change means rebuilding the database.

**Relational model** was proposed by **E. F. Codd** in his 1970 paper *"A Relational Model of Data for Large Shared Data Banks"*. Data and relationships are stored in tables. This is what MySQL, Oracle and the rest use, and it is what SQL works on.

## 3. Schema

A **schema** is the description of the database in terms of a data model.
Example relation schema: `Student(sid: string, name: string, age: integer)`. Every row must follow it.

(The actual data stored at one moment is called the *instance*. The schema changes rarely. The instance changes all the time.)

## 4. Three-schema architecture

A database can be described at three levels of abstraction:

```
 External level    ->  what each user / application sees (views)
        |
 Conceptual level  ->  all tables, columns, constraints (logical schema)
        |
 Physical level    ->  how and where data is stored on disk
```

| Schema | Purpose |
|---|---|
| **External** | Customised view for one user or group. Guided by end-user needs |
| **Conceptual** | All relations stored in the database. Choosing good tables, columns and constraints = *conceptual database design* |
| **Physical** | Storage strategy: files, indexes, placement |

## 5. Data independence

A big advantage of the three levels: one level can change without breaking the level above.

| Type | Meaning | Example |
|---|---|---|
| **Logical data independence** | Changing the conceptual schema should not break external schemas or applications | Add a new column to a table, existing reports still work |
| **Physical data independence** | Changing the physical storage should not affect the conceptual schema | Move the data to another disk or change the file format, tables look the same |

The DBMS stores all these schema descriptions in the **system catalog**.

## Check yourself

1. Which model allows a record to have more than one parent?
2. What is a schema?
3. A DBA moves table data to a faster disk and no SQL query needs changes. Which independence is this?

<details><summary>Answers</summary>

1. The network model.
2. The description of a database structure in terms of a data model (table names, columns, types, constraints).
3. Physical data independence.
</details>

---
Previous: [01](01_database_basics.md) | Next: [03 – RDBMS Concepts](03_rdbms_concepts.md)
