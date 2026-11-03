-- 02_dept_unique_constraint.sql  (Oracle)
-- PRIMARY KEY plus a composite UNIQUE constraint on (dname, loc).
-- Fixed from the original: the table name now matches the INSERTs (dept10),
-- and the constraint names are unique so they do not clash with an existing DEPT table.

CREATE TABLE dept10 (
    deptno NUMBER(2) CONSTRAINT dept10_deptno_pk PRIMARY KEY,
    dname  VARCHAR2(12),
    loc    VARCHAR2(10),
    CONSTRAINT dept10_dname_loc_unq UNIQUE (dname, loc)
);

INSERT INTO dept10 (deptno, loc, dname) VALUES (10, 'NEW YORK', 'ACCOUNTING');  -- column list given, so the order can differ
INSERT INTO dept10 VALUES (20, 'RESEARCH', 'DALLAS');                           -- no column list: order = deptno, dname, loc
INSERT INTO dept10 VALUES (30, 'SALES', NULL);                                  -- NULL is allowed in a UNIQUE column
INSERT INTO dept10 (deptno, loc) VALUES (40, 'BOSTON');                         -- dname is left out, so it is NULL

-- Try this: it FAILS in Oracle, because ('SALES', NULL) already exists and Oracle
-- compares the non-NULL part of a partly-NULL composite key. (MySQL would accept it.)
-- INSERT INTO dept10 VALUES (50, 'SALES', NULL);
