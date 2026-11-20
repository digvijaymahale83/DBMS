-- DBMS MYSQL PRACTICALS: ALL 9 PROGRAMS
-- IMPORTANT: Run each practical section separately, not the whole file at once.
-- Practicals 4-7 reuse Company.Employee with different structures.
-- Practicals 3 and 8 reuse Bank.Account with different structures.


------------------------------------------------------------------------------
-- FILE: 01_Library_DDL_DML.sql
------------------------------------------------------------------------------

-- PRACTICAL 1: Library database - DDL and DML
CREATE DATABASE IF NOT EXISTS Library;
USE Library;

DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID INT PRIMARY KEY,
    Book_Name VARCHAR(50),
    Author VARCHAR(50),
    Price DECIMAL(10,2),
    Quantity INT
);

INSERT INTO Books VALUES
(1, 'Python Basics', 'John', 450.00, 10),
(2, 'Java Programming', 'James', 650.00, 5),
(3, 'DBMS Concepts', 'Korth', 550.00, 8),
(4, 'C Programming', 'Dennis', 350.00, 12),
(5, 'Web Development', 'Peter', 700.00, 6);

-- Display all records
SELECT * FROM Books;

-- Update the price of a particular book
UPDATE Books
SET Price = 750.00
WHERE Book_ID = 2;

-- Delete a particular book
DELETE FROM Books
WHERE Book_ID = 4;

-- Add a new column
ALTER TABLE Books
ADD Publisher VARCHAR(50);

-- Display books with price greater than 500
SELECT * FROM Books
WHERE Price > 500;


------------------------------------------------------------------------------
-- FILE: 02_Hospital_DDL_DML.sql
------------------------------------------------------------------------------

-- PRACTICAL 2: Hospital database - DDL and DML
CREATE DATABASE IF NOT EXISTS Hospital;
USE Hospital;

DROP TABLE IF EXISTS Patient;

CREATE TABLE Patient (
    Patient_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    Disease VARCHAR(50),
    Fees DECIMAL(10,2)
);

INSERT INTO Patient VALUES
(1, 'Rahul', 22, 'Male', 'Fever', 500.00),
(2, 'Priya', 25, 'Female', 'Cold', 300.00),
(3, 'Amit', 30, 'Male', 'Diabetes', 1000.00),
(4, 'Sneha', 28, 'Female', 'Malaria', 800.00),
(5, 'Rohit', 35, 'Male', 'Typhoid', 1200.00);

-- Display all patients
SELECT * FROM Patient;

-- Update fees of a particular patient
UPDATE Patient
SET Fees = 1500.00
WHERE Patient_ID = 3;

-- Delete a particular patient
DELETE FROM Patient
WHERE Patient_ID = 4;

-- Add Contact column
ALTER TABLE Patient
ADD Contact VARCHAR(15);

-- Display final records
SELECT * FROM Patient;


------------------------------------------------------------------------------
-- FILE: 03_Bank_Withdrawal_Exception_Handling.sql
------------------------------------------------------------------------------

-- PRACTICAL 3: Bank withdrawal procedure with exception handling
CREATE DATABASE IF NOT EXISTS Bank;
USE Bank;

DROP PROCEDURE IF EXISTS WithdrawMoney;
DROP TABLE IF EXISTS Account;

CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Account_Name VARCHAR(50),
    Balance DECIMAL(10,2)
);

INSERT INTO Account VALUES
(101, 'Rahul', 10000.00),
(102, 'Amit', 15000.00),
(103, 'Priya', 20000.00),
(104, 'Sneha', 12000.00),
(105, 'Rohit', 8000.00);

DELIMITER //

CREATE PROCEDURE WithdrawMoney(
    IN p_account_no INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_account_found BOOLEAN DEFAULT TRUE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_account_found = FALSE;

    IF p_amount <= 0 THEN
        SELECT 'Error: Withdrawal amount must be greater than zero.' AS Message;
    ELSE
        SELECT Balance
        INTO v_balance
        FROM Account
        WHERE Account_No = p_account_no;

        IF v_account_found = FALSE THEN
            SELECT 'Error: Account does not exist.' AS Message;
        ELSEIF p_amount > v_balance THEN
            SELECT 'Error: Insufficient balance.' AS Message;
        ELSE
            UPDATE Account
            SET Balance = Balance - p_amount
            WHERE Account_No = p_account_no;

            SELECT 'Withdrawal successful.' AS Message;
        END IF;
    END IF;
END //

DELIMITER ;

-- Successful withdrawal
CALL WithdrawMoney(101, 2000.00);

-- Test account not found (uncomment to test)
-- CALL WithdrawMoney(999, 1000.00);

-- Test insufficient balance (uncomment to test)
-- CALL WithdrawMoney(101, 50000.00);

-- Test invalid amount (uncomment to test)
-- CALL WithdrawMoney(101, -500.00);

SELECT * FROM Account;


------------------------------------------------------------------------------
-- FILE: 04_Company_Cursor.sql
------------------------------------------------------------------------------

-- PRACTICAL 4: Display employee records using a cursor
CREATE DATABASE IF NOT EXISTS Company;
USE Company;

DROP PROCEDURE IF EXISTS DisplayEmployees;
DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department VARCHAR(30),
    Salary DECIMAL(10,2)
);

INSERT INTO Employee VALUES
(1, 'Rahul', 'IT', 50000.00),
(2, 'Amit', 'HR', 40000.00),
(3, 'Priya', 'IT', 60000.00),
(4, 'Sneha', 'Finance', 45000.00),
(5, 'Rohit', 'Sales', 35000.00);

DELIMITER //

CREATE PROCEDURE DisplayEmployees()
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);
    DECLARE v_department VARCHAR(30);
    DECLARE v_salary DECIMAL(10,2);

    DECLARE employee_cursor CURSOR FOR
        SELECT Employee_ID, Employee_Name, Department, Salary
        FROM Employee;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_done = 1;

    OPEN employee_cursor;

    read_loop: LOOP
        FETCH employee_cursor
        INTO v_id, v_name, v_department, v_salary;

        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT
            v_id AS Employee_ID,
            v_name AS Employee_Name,
            v_department AS Department,
            v_salary AS Salary;
    END LOOP;

    CLOSE employee_cursor;
END //

DELIMITER ;

CALL DisplayEmployees();


------------------------------------------------------------------------------
-- FILE: 05_Company_Nested_Queries.sql
------------------------------------------------------------------------------

-- PRACTICAL 5: Nested queries / subqueries
CREATE DATABASE IF NOT EXISTS Company;
USE Company;

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department VARCHAR(30),
    Salary DECIMAL(10,2)
);

INSERT INTO Employee VALUES
(1, 'Rahul', 'IT', 50000.00),
(2, 'Amit', 'HR', 40000.00),
(3, 'Priya', 'IT', 60000.00),
(4, 'Sneha', 'Finance', 45000.00),
(5, 'Rohit', 'Sales', 35000.00);

-- 1. Employees having salary greater than average salary
SELECT *
FROM Employee
WHERE Salary > (SELECT AVG(Salary) FROM Employee);

-- 2. Employee(s) having maximum salary
SELECT *
FROM Employee
WHERE Salary = (SELECT MAX(Salary) FROM Employee);

-- 3. Employees working in the IT department (using a subquery)
SELECT *
FROM Employee
WHERE Department = (
    SELECT Department
    FROM Employee
    WHERE Employee_Name = 'Rahul'
);

-- 4. Employees having salary greater than Rahul
SELECT *
FROM Employee
WHERE Salary > (
    SELECT Salary
    FROM Employee
    WHERE Employee_Name = 'Rahul'
);

-- 5. Employees working in the same department as Rahul
SELECT *
FROM Employee
WHERE Department = (
    SELECT Department
    FROM Employee
    WHERE Employee_Name = 'Rahul'
);


------------------------------------------------------------------------------
-- FILE: 06_Company_Joins.sql
------------------------------------------------------------------------------

-- PRACTICAL 6: INNER, LEFT, RIGHT, CROSS and FULL OUTER JOIN
CREATE DATABASE IF NOT EXISTS Company;
USE Company;

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

CREATE TABLE Department (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50)
);

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department_ID INT,
    Salary DECIMAL(10,2)
);

INSERT INTO Department VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Sales');

INSERT INTO Employee VALUES
(1, 'Rahul', 101, 50000.00),
(2, 'Amit', 102, 40000.00),
(3, 'Priya', 103, 60000.00),
(4, 'Sneha', 101, 45000.00),
(5, 'Rohit', NULL, 35000.00);

-- 1. INNER JOIN: only matching records
SELECT E.Employee_Name, D.Department_Name
FROM Employee AS E
INNER JOIN Department AS D
    ON E.Department_ID = D.Department_ID;

-- 2. LEFT JOIN: all employees and matching departments
SELECT E.Employee_Name, D.Department_Name
FROM Employee AS E
LEFT JOIN Department AS D
    ON E.Department_ID = D.Department_ID;

-- 3. RIGHT JOIN: all departments and matching employees
SELECT E.Employee_Name, D.Department_Name
FROM Employee AS E
RIGHT JOIN Department AS D
    ON E.Department_ID = D.Department_ID;

-- 4. CROSS JOIN: Cartesian product (5 x 4 = 20 rows)
SELECT E.Employee_Name, D.Department_Name
FROM Employee AS E
CROSS JOIN Department AS D;

-- 5. FULL OUTER JOIN equivalent in MySQL using UNION
SELECT E.Employee_Name, D.Department_Name
FROM Employee AS E
LEFT JOIN Department AS D
    ON E.Department_ID = D.Department_ID

UNION

SELECT E.Employee_Name, D.Department_Name
FROM Employee AS E
RIGHT JOIN Department AS D
    ON E.Department_ID = D.Department_ID;


------------------------------------------------------------------------------
-- FILE: 07_Company_Built_in_Functions.sql
------------------------------------------------------------------------------

-- PRACTICAL 7: MySQL built-in and aggregate functions
CREATE DATABASE IF NOT EXISTS Company;
USE Company;

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department VARCHAR(30),
    Salary DECIMAL(10,2)
);

INSERT INTO Employee VALUES
(1, 'Rahul', 'IT', 50000.00),
(2, 'Amit', 'HR', 40000.00),
(3, 'Priya', 'IT', 60000.00),
(4, 'Sneha', 'Finance', 45000.00),
(5, 'Rohit', 'Sales', 35000.00);

-- 1. Total salary
SELECT SUM(Salary) AS Total_Salary
FROM Employee;

-- 2. Average salary
SELECT AVG(Salary) AS Average_Salary
FROM Employee;

-- 3. Employee names in uppercase
SELECT UPPER(Employee_Name) AS Upper_Name
FROM Employee;

-- 4. Minimum salary
SELECT MIN(Salary) AS Minimum_Salary
FROM Employee;

-- 5. Department-wise employee count
SELECT Department, COUNT(*) AS Total_Employees
FROM Employee
GROUP BY Department;

-- Additional functions requested in the practical
SELECT COUNT(*) AS Employee_Count FROM Employee;
SELECT MAX(Salary) AS Maximum_Salary FROM Employee;
SELECT LOWER(Employee_Name) AS Lower_Name FROM Employee;
SELECT ROUND(AVG(Salary), 2) AS Rounded_Average_Salary FROM Employee;


------------------------------------------------------------------------------
-- FILE: 08_Bank_Triggers.sql
------------------------------------------------------------------------------

-- PRACTICAL 8: Triggers for account INSERT and UPDATE logging
CREATE DATABASE IF NOT EXISTS Bank;
USE Bank;

DROP TRIGGER IF EXISTS after_account_insert;
DROP TRIGGER IF EXISTS after_account_update;
DROP TABLE IF EXISTS Account_Log;
DROP TABLE IF EXISTS Account;

CREATE TABLE Account (
    Account_ID INT PRIMARY KEY,
    Account_Name VARCHAR(50),
    Balance DECIMAL(10,2)
);

CREATE TABLE Account_Log (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Account_ID INT,
    Account_Name VARCHAR(50),
    Balance DECIMAL(10,2),
    Action_Type VARCHAR(20),
    Action_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER after_account_insert
AFTER INSERT ON Account
FOR EACH ROW
BEGIN
    INSERT INTO Account_Log
        (Account_ID, Account_Name, Balance, Action_Type)
    VALUES
        (NEW.Account_ID, NEW.Account_Name, NEW.Balance, 'INSERT');
END //

CREATE TRIGGER after_account_update
AFTER UPDATE ON Account
FOR EACH ROW
BEGIN
    INSERT INTO Account_Log
        (Account_ID, Account_Name, Balance, Action_Type)
    VALUES
        (NEW.Account_ID, NEW.Account_Name, NEW.Balance, 'UPDATE');
END //

DELIMITER ;

INSERT INTO Account VALUES
(101, 'Rahul', 10000.00),
(102, 'Amit', 15000.00),
(103, 'Priya', 20000.00),
(104, 'Sneha', 12000.00),
(105, 'Rohit', 8000.00);

UPDATE Account
SET Balance = 15000.00
WHERE Account_ID = 101;

SELECT * FROM Account;
SELECT * FROM Account_Log;


------------------------------------------------------------------------------
-- FILE: 09_Shop_Stored_Procedures.sql
------------------------------------------------------------------------------

-- PRACTICAL 9: Product operations using stored procedures
CREATE DATABASE IF NOT EXISTS Shop;
USE Shop;

DROP PROCEDURE IF EXISTS DisplayProducts;
DROP PROCEDURE IF EXISTS InsertProduct;
DROP PROCEDURE IF EXISTS UpdateProductPrice;
DROP PROCEDURE IF EXISTS DeleteProduct;
DROP TABLE IF EXISTS Product;

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50),
    Price DECIMAL(10,2),
    Quantity INT
);

INSERT INTO Product VALUES
(1, 'Laptop', 50000.00, 10),
(2, 'Mouse', 500.00, 20),
(3, 'Keyboard', 1000.00, 15),
(4, 'Monitor', 12000.00, 8),
(5, 'Printer', 8000.00, 5);

DELIMITER //

-- 1. Display all products
CREATE PROCEDURE DisplayProducts()
BEGIN
    SELECT * FROM Product;
END //

-- 2. Insert a product
CREATE PROCEDURE InsertProduct(
    IN p_id INT,
    IN p_name VARCHAR(50),
    IN p_price DECIMAL(10,2),
    IN p_quantity INT
)
BEGIN
    INSERT INTO Product
    VALUES (p_id, p_name, p_price, p_quantity);
END //

-- 3. Update product price
CREATE PROCEDURE UpdateProductPrice(
    IN p_id INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    UPDATE Product
    SET Price = p_new_price
    WHERE Product_ID = p_id;
END //

-- 4. Delete a product
CREATE PROCEDURE DeleteProduct(
    IN p_id INT
)
BEGIN
    DELETE FROM Product
    WHERE Product_ID = p_id;
END //

DELIMITER ;

-- Execute the procedures
CALL DisplayProducts();
CALL InsertProduct(6, 'Headphones', 2000.00, 12);
CALL UpdateProductPrice(2, 700.00);
CALL DeleteProduct(5);
CALL DisplayProducts();
