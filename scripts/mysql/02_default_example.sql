-- 02_default_example.sql  (MySQL 8.0.13+)
-- DEFAULT: the default is used only when the column is left out, or the word DEFAULT is written.
USE sql_notes;

CREATE TABLE hire_demo (
    id        INT,
    hire_date DATE DEFAULT (CURRENT_DATE)
);

INSERT INTO hire_demo VALUES (45, NULL);      -- hire_date = NULL  (explicit NULL beats the default)
INSERT INTO hire_demo (id) VALUES (35);       -- hire_date = today (column left out)
INSERT INTO hire_demo VALUES (25, DEFAULT);   -- hire_date = today (DEFAULT keyword)

SELECT * FROM hire_demo;
