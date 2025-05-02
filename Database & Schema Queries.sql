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

