# Library Management System
## Project Overview
This project demonstrates the implementation of a Library Management System. Using SQL to create a Database, import the data, manage table relationships, perform CRUD operations, and executing advanced SQL queries. With this project I had the goal of demonstrating skills in database design, data manipulation, and querying.

## Objectives
1. **Set up the Library Management System Database**: Create the database and then populate with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform, Create, Read, Update, and Delete operations on the data.
3. **CTAS Operations (Create Table As Select**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data. Create Store Procedures to automate issuing queries and return queries

## Project Structure

### 1. Database Setup
**INSERT PICTURE OF ERD**

- **Database Creation**: Created a database named **'library_management_project**.
- **Table Creation**: Created tables named branches, employees, members, books, issued_status, and return status. Each table includes relevant columns and relationship to one another.

```sql
  -- Library Management System Project
  
	-- Creating branch table
	DROP TABLE IF EXISTS branch;
	CREATE TABLE branch
		(
			branch_id VARCHAR(10) PRIMARY KEY, 
			manager_id VARCHAR(10),
			branch_address VARCHAR(55),
			contact_no VARCHAR(10)
		);

	-- Create employee table
	DROP TABLE IF EXISTS employees;
	CREATE TABLE employees
		(
			emp_id VARCHAR(10) PRIMARY KEY, 
			emp_name VARCHAR(55),
			position VARCHAR(55),
			salary INT,
			branch_id VARCHAR(10)
		);

	-- Create books table
	DROP TABLE IF EXISTS books;
	CREATE TABLE books
		(
			isbn VARCHAR(75) PRIMARY KEY,
			book_title VARCHAR(75),
			category VARCHAR(75),
			rental_price FLOAT,
			status VARCHAR(75),
			author VARCHAR(75),
			publisher VARCHAR(75)
		);

	-- Create members table
	DROP TABLE IF EXISTS members;
	CREATE TABLE members
		(
			member_id VARCHAR(75) PRIMARY KEY,
			member_name VARCHAR(75),
			member_address VARCHAR(75),
			reg_date DATE
		);
	
	-- Create issue status table
	DROP TABLE IF EXISTS issued_status;
	CREATE TABLE issued_status
		(
			issued_id VARCHAR(75) PRIMARY KEY,
			issued_member_id VARCHAR(75),
			issued_book_name VARCHAR(75),
			issued_date DATE,
			issued_book_isbn VARCHAR(75),
			issued_emp_id VARCHAR(75)
		);
	
	-- Create return_status
	DROP TABLE IF EXISTS return_status;
	CREATE TABLE return_status
		(
			return_id VARCHAR(75) PRIMARY KEY,
			issued_id VARCHAR(75),
			return_book_name VARCHAR(75),
			return_date DATE,
			return_book_isbn VARCHAR(75)
		);
	
	-- Add Foreign Keys
	
	-- issued_status table
	ALTER TABLE issued_status
	ADD CONSTRAINT fk_members
	FOREIGN KEY (issued_member_id)
	REFERENCES members(member_id);
	
	ALTER TABLE issued_status
	ADD CONSTRAINT fk_books
	FOREIGN KEY (issued_book_isbn)
	REFERENCES books(isbn);
	
	ALTER TABLE issued_status
	ADD CONSTRAINT fk_employees
	FOREIGN KEY (issued_emp_id)
	REFERENCES employees(emp_id);
	
	-- employees table
	ALTER TABLE employees
	ADD CONSTRAINT fk_branch
	FOREIGN KEY (branch_id)
	REFERENCES branch(branch_id);
	
	-- return_status table
	ALTER TABLE return_status
	ADD CONSTRAINT fk_issued_status
	FOREIGN KEY (issued_id)
	REFERENCES issued_status(issued_id);
```

  ### 2. CRUD Operations

**Task 1. Create a New Book Record**

-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

  ```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
  ```
**Task 2. Update an Existing Member's Address**

-- Objective update employee ID # C103's address to '125 Oak St'.

 ```sql
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
  ```
**Task 3. Delete a Record from the Issued Status Table**

-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

 ```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
  ```
**Task 4. Retrieve All Books Issued by a Specific Employee**

-- Objective: Select all books issued by the employee with emp_id = 'E101'.

```sql
SELECT issued_book_name
FROM issued_status
WHERE issued_emp_id = 'E101';
```
**Task 5. List Employees Who Have Issued More Than One Book**

-- Objective: Use a GROUP BY to find members who have issued more than 1 book.

```sql
SELECT issued_emp_id -- COUNT(*) AS num_of_issues
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1;
  ```
### 3. CTAS Operations

**Task 6. Create a Summary Table for Books and Issued Count**

-- Objective create table that shows ISBN, Book Name, and Issued Count based on query results.

```sql
CREATE TABLE book_issue_counts
AS
SELECT b.isbn, b.book_title, COUNT(*) AS times_issued
FROM books AS b
JOIN issued_status as iss
	ON iss.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_issue_counts;
```
**Task 7. Create a Summary Table for Books with Rental Price Above a Certain Threshold**

-- Objective create table that shows ISBN, Book Name, Rental Price (only above **INSERT RENTAL PRICE**)

```sql
CREATE TABLE high_price_rental_books
AS 
SELECT * 
FROM books
WHERE rental_price >= 7;

SELECT * FROM high_price_rental_books;
```

### 4. Advanced SQL Queries

**Task 8. Retrieve All Books in a Specific Category**

-- Objective: Return all books in the 'Classic' Category

```sql
SELECT *
FROM books
WHERE category = 'Classic';
```
**Task 9. Find Total Rental Income by Category**

-- Objective: Use GROUP BY function to get rental income by category

```sql
SELECT b.category, COUNT(*) AS issue_count, SUM(rental_price) AS total_rental_income
FROM books AS b
JOIN issued_status AS iss
	ON iss.issued_book_isbn = b.isbn
GROUP BY b.category
ORDER BY total_rental_income DESC;
```
**Task 10. List Members Who Registered in the Last 180 Days**

```sql
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```
**Task 11. List Employees with their Branch Manager's Name and Their Branch Details**

-- Objective: JOIN all necessary tables to provide Employee ID, Employee Name, Employee Position, Employee Salary, Manager Name, and all Branch Details

```sql
SELECT e1.emp_id, e1.emp_name, b.manager_id, e2.emp_name as manager_name, b.branch_id, b.branch_address, b.contact_no
FROM employees AS e1
JOIN branch AS b
	ON e1.branch_id = b.branch_id
JOIN employees AS e2
	ON b.manager_id = e2.emp_id
WHERE e1.position != 'Manager';
```
**Task 12. Retrieve the List of Books Not Yet Returned**

```sql
SELECT DISTINCT iss.issued_book_name
FROM issued_status AS iss
LEFT JOIN return_status AS ret
	ON iss.issued_id = ret.issued_id
WHERE ret.return_id IS NULL;
```
**Task 13. Identify Members with Overdue Books**

-- Objective: Identify memebers who have overdue books. Assume a 30 Day Return Period. Return Member ID, Member Name, Book Title, Issue Date, and Days Overdue. 

```sql
-- join these tables: issued_satatus - members - books - return_status

SELECT iss.issued_member_id, 
		m.member_name, 
		b.book_title, 
		iss.issued_date,
		CURRENT_DATE - (issued_date + INTERVAL '30 Days')::DATE AS days_overdue
FROM issued_status AS iss
JOIN members AS m
 	ON m.member_id = iss.issued_member_id
JOIN books AS b
	ON b.isbn = iss.issued_book_isbn
LEFT JOIN return_status AS ret
	ON ret.issued_id = iss.issued_id
WHERE ret.return_date IS NULL
	AND CURRENT_DATE - (issued_date + INTERVAL '30 Days')::DATE > 30
ORDER BY 1;
```
**Task 14. Update Book Status on Return**

-- Objective: Create a Stored Procedure to update the status of a book to 'yes' when they are returned. Base it on entries in the return status table.

```sql
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(75), p_issued_id VARCHAR(75))
LANGUAGE plpgsql
AS $$
DECLARE 
	v_isbn VARCHAR(50);
	v_book_name VARCHAR(80);

BEGIN
	-- Insert returns data based on users input
	INSERT INTO return_status(return_id, issued_id, return_date)
	VALUES (p_return_id, p_issued_id, CURRENT_DATE);


	-- Creating variables, updating status of book, and notifying completion of procedure
	SELECT issued_book_isbn, issued_book_name
		INTO v_isbn, v_book_name
	FROM issued_status
	WHERE issued_id = p_issued_id;
	
	UPDATE books
	SET status = 'yes'
	WHERE isbn = v_isbn;
	
	RAISE NOTICE 'Thank you for returning: %', v_book_name;
	
END;
$$
```
**Task 15. Create a Branch Performance Report**

-- Objective: Create a performance report for each branch. Show the number of books issued, number returned, and total revenue generated from rentals.

```sql
CREATE TABLE branch_report1 AS
SELECT bra.branch_id,
		bra.manager_id,
		SUM(b.rental_price) AS total_revenue,
		COUNT(iss.issued_id) AS num_of_books_issued,
		COUNT(ret.return_id) AS num_of_books_returned
FROM issued_status AS iss
JOIN employees AS e
	ON iss.issued_emp_id = e.emp_id
JOIN branch AS bra
 	ON e.branch_id = bra.branch_id
LEFT JOIN return_status AS ret
	ON ret.issued_id = iss.issued_id
JOIN books AS b
	ON b.isbn = iss.issued_book_isbn
GROUP BY 1, 2

SELECT * FROM branch_report1;
```
**Task 16. Create a Table of Active Members**

-- Objective: Create a new table that contains only active members. Active members being those who have been issued a book in the last 6 Months.

```sql
CREATE TABLE active_members AS
WITH active_members AS
(
SELECT DISTINCT issued_member_id
FROM issued_status
WHERE issued_date > CURRENT_DATE - INTERVAL '6 month'
)
SELECT *
FROM active_members AS act
JOIN members AS mem
	ON act.issued_member_id = mem.member_id

SELECT *
FROM active_members;
```
**Task 17. Find Employees with the Most Book Issues Processed**

-- Objective: Find the top 3 Employees who have issued the most books. Display the Employee Name, Number of Books Processed, and Their Branch Info

```sql
-- This if you just want these 3 columns
SELECT emp.emp_name,
		COUNT(iss.issued_id) AS books_issued,
		emp.branch_id
FROM employees AS emp
JOIN issued_status AS iss
	ON emp.emp_id = iss.issued_emp_id
GROUP BY 1,3
ORDER BY books_issued DESC
LIMIT 3;

-- This if you want the 2 columns and all branch info
SELECT emp.emp_name,
		COUNT(iss.issued_id) AS books_issued,
		bra.*
FROM employees AS emp
JOIN issued_status AS iss
	ON emp.emp_id = iss.issued_emp_id
JOIN branch AS bra
	ON emp.branch_id = bra.branch_id
GROUP BY 1,3
ORDER BY books_issued DESC
LIMIT 3;
```
**Task 18. Create a Stored Procedure to Manage Issuing Books**

-- Objective: Write a procdedure that updates the status of a book based on its issuance. Should follow this logic:
1. Procedure should take the Book ISBN as input parameter.
2. Then check to see if the book is available (status = 'yes').
3. If the book is available then it should be issued and the status changed to 'no'.
4. If the book is not available (status = 'no'), then an error message should be returned that the book is not available.

```sql
CREATE OR REPLACE PROCEDURE issue_management(p_issued_id VARCHAR(75), 
												p_issued_member_id VARCHAR(75), 
												p_issued_book_isbn VARCHAR(75), 
												p_issued_emp_id VARCHAR(75))
LANGUAGE plpgsql
AS $$
DECLARE 
	v_status VARCHAR(75);

BEGIN
	-- Check if the book is available = 'yes'
	SELECT status INTO v_status
	FROM books
	WHERE isbn = p_issued_book_isbn;

	IF v_status = 'yes' THEN 
		INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES(p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

	UPDATE books
	SET status = 'no'
	WHERE isbn = p_issued_book_isbn;

	RAISE NOTICE 'Book record added successfully for book ISBN: %', p_issued_book_isbn;

	ELSE 
		RAISE NOTICE 'The book you have requested is unavailable. Book ISBN: %', p_issued_book_isbn;

	END IF;
	
END;
$$
```
**Task 19. Identify Overdue Books and Calculate the Fines Due**

-- Objective: Determine what members have overdue books and calculate the fines they owe. Fines calculated at $.50/Day/. Table should include: Member ID, Number of Overdue Books, and Total Fines

```sql
  INSERT CODE BELOW
  ```

## Conclusion
Through this project I have demonstrated my ability to create a database and manage the relationships between them. Along with that updating the table by inserting new data and deleting values that need to be deleted. While also generating reports and pulling information that stakeholders may ask for to drive business decisions. 

Project Data from Zero Analyst. Link to their information below:
- [**GitHub Link**](https://github.com/najirh/Library-System-Management---P2.git)
- [**LinkedIn**](https://www.linkedin.com/in/najirr)

















