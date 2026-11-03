-- 01_constraints_demo.sql
-- Demo of NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK and ON DELETE.
-- Written for MySQL 8.0.16+ (CHECK is enforced from that version).
-- The same statements also work in Oracle (INT, VARCHAR and DECIMAL are accepted).
--
-- To re-run: DROP TABLE employees; DROP TABLE departments;   (child first, then parent)
-- (the ON DELETE tables at the bottom: DROP TABLE products_cascade, products_setnull, supplier;)

CREATE DATABASE IF NOT EXISTS sql_notes;
USE sql_notes;

-- ---------- 1. Parent table ----------
CREATE TABLE departments (
    department_id   INT,
    department_name VARCHAR(30) NOT NULL,
    location        VARCHAR(30),
    CONSTRAINT dept_id_pk PRIMARY KEY (department_id)
);

-- ---------- 2. Child table ----------
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

-- ---------- 3. Valid rows (all succeed) ----------
INSERT INTO departments VALUES (10, 'Accounting', 'New York');
INSERT INTO departments VALUES (20, 'Research',   'Dallas');
INSERT INTO employees VALUES (1, 'Smith', 'smith@example.com', 800.00, DATE '2024-01-15', 10);
INSERT INTO employees VALUES (2, 'Jones', NULL,                2975.00, DATE '2024-02-01', 20);  -- NULL email is fine for UNIQUE
INSERT INTO employees VALUES (3, 'Allen', NULL,                1600.00, DATE '2024-03-10', NULL); -- NULL foreign key is fine

-- ---------- 4. Violations: each statement below FAILS. Run them one at a time. ----------
-- INSERT INTO employees VALUES (1, 'Ford',  'ford@example.com', 3000, DATE '2024-04-01', 10);  -- duplicate PRIMARY KEY
-- INSERT INTO employees VALUES (4, NULL,    'x@example.com',    3000, DATE '2024-04-01', 10);  -- NOT NULL on last_name
-- INSERT INTO employees VALUES (4, 'Adams', 'smith@example.com', 3000, DATE '2024-04-01', 10);  -- duplicate UNIQUE email
-- INSERT INTO employees VALUES (4, 'Adams', 'adams@example.com', -5,   DATE '2024-04-01', 10);  -- CHECK salary > 0
-- INSERT INTO employees VALUES (4, 'Adams', 'adams@example.com', 3000, DATE '2024-04-01', 99);  -- FOREIGN KEY: no department 99
-- DELETE FROM departments WHERE department_id = 10;                                             -- FOREIGN KEY: employee 1 still refers to it

-- ---------- 5. ON DELETE CASCADE vs ON DELETE SET NULL ----------
CREATE TABLE supplier (
    supplier_id   INT,
    supplier_name VARCHAR(50) NOT NULL,
    CONSTRAINT supplier_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE products_cascade (
    product_id  INT,
    supplier_id INT NOT NULL,
    CONSTRAINT pc_pk PRIMARY KEY (product_id),
    CONSTRAINT pc_fk FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id) ON DELETE CASCADE
);

-- For SET NULL the foreign key column must allow NULL (no NOT NULL here)
CREATE TABLE products_setnull (
    product_id  INT,
    supplier_id INT,
    CONSTRAINT ps_pk PRIMARY KEY (product_id),
    CONSTRAINT ps_fk FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id) ON DELETE SET NULL
);

INSERT INTO supplier         VALUES (1, 'Acme Tools');
INSERT INTO products_cascade VALUES (100, 1);
INSERT INTO products_setnull VALUES (200, 1);

DELETE FROM supplier WHERE supplier_id = 1;

SELECT * FROM products_cascade;   -- 0 rows: the child row was deleted with its parent
SELECT * FROM products_setnull;   -- 1 row:  product 200, supplier_id is now NULL
