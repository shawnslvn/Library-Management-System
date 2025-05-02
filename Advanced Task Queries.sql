-- Library Management System Project

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

-- Advanced Project Tasks

/* Task 1. Identify members with overdue books
Assume a 30 Day Return-Period. Display the member's ID, name, 
book title, issue date, and days overdue */

SELECT *
FROM issued_status;

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

/* Task 2. Update Book status on in books table based on return table 
Write Stored Procedure to update book status to 'yes' when they are returned
based on entries in the return_status table 
Use book ISBN "978-0-307-58837-1", "Sapiens: A Brief History of Humankind" 
and book ISBN "978-0-375-41398-8", "The Diary of a Young Girl"*/

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

CALL add_return_records('RS119', 'IS135')
CALL add_return_records('RS120', 'IS134')

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1'
	OR isbn = '978-0-375-41398-8'; -- Now the statuses are updated

/* Task 3. Create a branch performance report that generates for each branch 
showing the number of books issued, the number of books returned, and the total 
revenue generated from book rentals */

-- need to join: issued_status to employees to branch to return_status to books
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

/* Task 4. Create a table of active members. Active members being those that have
issued at least one book in the last 6 months*/
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

/* Task 5. Find the top 3 employees who have issued the most books. Display the
name, number of books issued, and their branch */

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

/* Task 6. Create a Stored Procedure to manage the status of books in Library Management System.
Should operate as follows: Take book_id as input parameter. Procedure then checks if the books is available
in the system, 'yes'. If the book is available, it should be issued, and the status of the book should be
updated to 'no'. If the book is not available the procedure should return an error message indicating
that the book is currently not available */

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

CALL issue_management('IS141', 'C110', '978-0-553-29698-2', 'E102');
CALL issue_management('IS142', 'C109', '978-0-7432-7357-1', 'E105');

-- "978-0-553-29698-2" = Yes
-- "978-0-7432-7357-1" = No

/* Task 7. Create a table that shows members who have not returned books within 30 days and 
calculate the amount of fines they must pay.Fine is calculated at $0.50/Day. Table should include:
Member ID, Member Name, # of overdue books, and Total Fines */
SELECT mem.member_id, 
		mem.member_name, 
		COUNT(member_id) AS books_overdue,
		SUM((CURRENT_DATE - (iss.issued_date + INTERVAL '30 Days')::DATE) * 0.50) AS total_fines	
FROM members AS mem
JOIN issued_status AS iss
	ON iss.issued_member_id = mem.member_id
LEFT JOIN return_status AS ret
	ON ret.issued_id = iss.issued_id
JOIN books AS b
	ON b.isbn = iss.issued_book_isbn
WHERE return_date IS NULL 
	AND CURRENT_DATE - (iss.issued_date + INTERVAL '30 Days')::DATE > 0
GROUP BY 1,2