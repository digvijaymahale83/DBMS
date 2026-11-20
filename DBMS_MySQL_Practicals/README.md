# DBMS MySQL Practicals (9 Programs)

This repository contains all 9 DBMS practical programs written for **MySQL** and designed to run in **MySQL Workbench**.

## Programs

| No. | File | Topic |
|---|---|---|
| 1 | `01_Library_DDL_DML.sql` | Library database: DDL and DML |
| 2 | `02_Hospital_DDL_DML.sql` | Hospital database: DDL and DML |
| 3 | `03_Bank_Withdrawal_Exception_Handling.sql` | Stored procedure with exception handling |
| 4 | `04_Company_Cursor.sql` | Cursor to display employee records |
| 5 | `05_Company_Nested_Queries.sql` | Nested queries / subqueries |
| 6 | `06_Company_Joins.sql` | INNER, LEFT, RIGHT, CROSS and FULL OUTER JOIN equivalent |
| 7 | `07_Company_Built_in_Functions.sql` | Aggregate and built-in functions |
| 8 | `08_Bank_Triggers.sql` | INSERT and UPDATE triggers with account log |
| 9 | `09_Shop_Stored_Procedures.sql` | Procedures to display, insert, update and delete products |

## How to run in MySQL Workbench

1. Open MySQL Workbench and connect to your local MySQL server.
2. Open one `.sql` file using **File → Open SQL Script**.
3. Execute the script using the lightning bolt button.
4. Check the **Result Grid** and **Action Output** panels.

## Important notes

- Run each practical file separately.
- Each file creates or reuses its database and recreates its own tables. Existing data in those specific tables may be deleted when the file is rerun.
- Practical 4, 5, 6 and 7 all use the `Company` database and the `Employee` table with different structures. Run them one at a time.
- Practical 3 and 8 both use the `Bank` database but have different `Account` table structures. Run them one at a time.
- The scripts use MySQL syntax. They are not intended for SQL Server or Oracle.
- Practical 6 implements FULL OUTER JOIN behavior using `LEFT JOIN`, `RIGHT JOIN` and `UNION`, because MySQL does not provide a direct `FULL OUTER JOIN` keyword.

## Suggested GitHub repository name

`dbms-mysql-practicals`

## Suggested repository description

`Collection of 9 DBMS practical programs using MySQL, covering DDL, DML, stored procedures, exception handling, cursors, subqueries, joins, built-in functions and triggers.`
