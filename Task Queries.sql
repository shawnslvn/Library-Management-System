-- Library Management Project

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

-- Project Tasks

-- Task 1. Create a New Book Record -- "978-1-60129-456-2", "To Kill a Mockingbird", "Classic", 6.00, "yes", "Harper Lee", "J.B. Lippincott & Co."

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Task 2. Update an Existing Member Address
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;

-- Task 3. Delete a Record from the Issued Status Table where issued_id = 'IS121'
DELETE FROM issued_status
WHERE issued_id = 'IS121';
SELECT * FROM issued_status;

-- Task 4. Retrieve all books issued by a employee 'E101'
SELECT issued_book_name
FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5. List Employees who have issued more than one book
SELECT issued_emp_id -- COUNT(*) AS num_of_issues
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1;

-- Task 6. Create a new table based on query results. Table shoul be each book and total times book has been issued
CREATE TABLE book_issue_counts
AS
SELECT b.isbn, b.book_title, COUNT(*) AS times_issued
FROM books AS b
JOIN issued_status as iss
	ON iss.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_issue_counts;

-- Task 7. Retrieve all books from the 'Classic' Category
SELECT *
FROM books
WHERE category = 'Classic';

-- Task 8. Find Total Rental Income by Category
SELECT b.category, COUNT(*) AS issue_count, SUM(rental_price) AS total_rental_income
FROM books AS b
JOIN issued_status AS iss
	ON iss.issued_book_isbn = b.isbn
GROUP BY b.category
ORDER BY total_rental_income DESC;

-- Task 9. List the members who registered in the last 180 Days
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Task 10. List employees with their Branch Manager's Name # and their Branch Details
SELECT * FROM branch;
SELECT * FROM employees;

SELECT e1.emp_id, e1.emp_name, b.manager_id, e2.emp_name as manager_name, b.branch_id, b.branch_address, b.contact_no
FROM employees AS e1
JOIN branch AS b
	ON e1.branch_id = b.branch_id
JOIN employees AS e2
	ON b.manager_id = e2.emp_id
WHERE e1.position != 'Manager';

-- Task 11. Create a table of books with a rental price of $7 or more
CREATE TABLE high_price_rental_books
AS 
SELECT * 
FROM books
WHERE rental_price >= 7;

SELECT * FROM high_price_rental_books;

-- Task 12. Retrieve the list of books not yet returned
SELECT DISTINCT iss.issued_book_name
FROM issued_status AS iss
LEFT JOIN return_status AS ret
	ON iss.issued_id = ret.issued_id
WHERE ret.return_id IS NULL;

SELECT * FROM issued_status;
SELECT * FROM return_status;



