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
  INSERT CODE BELOW
  ```
**Task 2. Update an Existing Member's Address**

-- Objective update employee ID # C103's address to '125 Oak St'.

 ```sql
  INSERT CODE BELOW
  ```
**Task 3. Delete a Record from the Issued Status Table**

-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

 ```sql
  INSERT CODE BELOW
  ```
**Task 4. Retrieve All Books Issued by a Specific Employee**

-- Objective: Select all books issued by the employee with emp_id = 'E101'.

```sql
  INSERT CODE BELOW
  ```
**Task 5. List Members Who Have Issued More Than One Book**

-- Objective: Use a GROUP BY to find members who have issued more than 1 book.

```sql
  INSERT CODE BELOW
  ```

### 3. CTAS Operations

**Task 6. Create a Summary Table for Books and Issued Count**

-- Objective create table that shows ISBN, Book Name, and Issued Count based on query results.

```sql
  INSERT CODE BELOW
  ```
**Task 7. Create a Summary Table for Books with Rental Price Above a Certain Threshold**

-- Objective create table that shows ISBN, Book Name, Rental Price (only above **INSERT RENTAL PRICE**)

```sql
  INSERT CODE BELOW
  ```

### 4. Advanced SQL Queries

**Task 8. Retrieve All Books in a Specific Category**

-- Objective: Return all books in the 'Classic' Category

```sql
  INSERT CODE BELOW
  ```
**Task 9. Find Total Rental Income by Category**

-- Objective: Use GROUP BY function to get rental income by category

```sql
  INSERT CODE BELOW
  ```
**Task 10. List Members Who Registered in the Last 180 Days**

```sql
  INSERT CODE BELOW
  ```
**Task 11. List Employees with their Branch Manager's Name and Their Branch Details**

-- Objective: JOIN all necessary tables to provide Employee ID, Employee Name, Employee Position, Employee Salary, Manager Name, and all Branch Details

```sql
  INSERT CODE BELOW
  ```
**Task 12. Retrieve the List of Books Not Yet Returned**

```sql
  INSERT CODE BELOW
  ```
**Task 13. Identify Members with Overdue Books**

-- Objective: Identify memebers who have overdue books. Assume a 30 Day Return Period. Return Member ID, Member Name, Book Title, Issue Date, and Days Overdue. 

```sql
  INSERT CODE BELOW
  ```
**Task 14. Update Book Status on Return**

-- Objective: Create a Stored Procedure to update the status of a book to 'yes' when they are returned. Base it on entries in the return status table.

```sql
  INSERT CODE BELOW
  ```
**Task 15. Create a Branch Performance Report**

-- Objective: Create a performance report for each branch. Show the number of books issued, number returned, and total revenue generated from rentals.

```sql
  INSERT CODE BELOW
  ```
**Task 16. Create a Table of Active Members**

-- Objective: Create a new table that contains only active members. Active members being those who have been issued a book in the last 6 Months.

```sql
  INSERT CODE BELOW
  ```
**Task 17. Find Employees with the Most Book Issues Processed**

-- Objective: Find the top 3 Employees who have issued the most books. Display the Employee Name, Number of Books Processed, and Their Branch

```sql
  INSERT CODE BELOW
  ```
**Task 18. Create a Stored Procedure to Manage Issuing Books**

-- Objective: Write a procdedure that updates the status of a book based on its issuance. Should follow this logic:
1. Procedure should take the Book ISBN as input parameter.
2. Then check to see if the book is available (status = 'yes').
3. If the book is available then it should be issued and the status changed to 'no'.
4. If the book is not available (status = 'no'), then an error message should be returned that the book is not available.

```sql
  INSERT CODE BELOW
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

















