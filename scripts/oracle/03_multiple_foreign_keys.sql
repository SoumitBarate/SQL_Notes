-- 03_multiple_foreign_keys.sql  (Oracle)
-- Fixed from the original: unique constraint names, no trailing comma,
-- and the second example now has its own parent tables.

-- ===== Example A: one child table with TWO foreign keys (one per parent) =====
CREATE TABLE table1 (
    id_table1 NUMBER(2) PRIMARY KEY,
    value     VARCHAR2(5)
);

CREATE TABLE table2 (
    id_table2 NUMBER(2) PRIMARY KEY,
    value     VARCHAR2(5)
);

CREATE TABLE table3 (
    id_table3     NUMBER(2) PRIMARY KEY,
    value         VARCHAR2(5),
    rel_id_table1 NUMBER(2),
    rel_id_table2 NUMBER(2),
    CONSTRAINT fk_table3_table1 FOREIGN KEY (rel_id_table1) REFERENCES table1 (id_table1),
    CONSTRAINT fk_table3_table2 FOREIGN KEY (rel_id_table2) REFERENCES table2 (id_table2)
);

-- ===== Example B: composite primary key where each part is also a foreign key =====
-- (this is the "junction table" pattern used for many-to-many relationships)
CREATE TABLE parent_a (
    a VARCHAR2(4) PRIMARY KEY
);

CREATE TABLE parent_b (
    b VARCHAR2(10) PRIMARY KEY
);

CREATE TABLE child_ab (
    a VARCHAR2(4),
    c VARCHAR2(10),
    e CHAR(1),
    CONSTRAINT pk_child_ab_a_c PRIMARY KEY (a, c),
    CONSTRAINT fk_child_ab_a   FOREIGN KEY (a) REFERENCES parent_a (a),
    CONSTRAINT fk_child_ab_c   FOREIGN KEY (c) REFERENCES parent_b (b)
);
