-- 01_default_example.sql  (Oracle)
-- DEFAULT: the default is used only when the column is left out, or the word DEFAULT is written.

CREATE TABLE hire_date (
    id        NUMBER(8),
    hire_date DATE DEFAULT SYSDATE
);

INSERT INTO hire_date VALUES (45, NULL);      -- hire_date = NULL  (explicit NULL beats the default)
-- When you leave the DEFAULT column out, list the columns you ARE giving:
INSERT INTO hire_date (id) VALUES (35);       -- hire_date = SYSDATE
INSERT INTO hire_date VALUES (25, DEFAULT);   -- hire_date = SYSDATE

SELECT * FROM hire_date;
