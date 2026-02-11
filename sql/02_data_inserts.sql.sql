INSERT INTO branch (branch_id, manager_id, branch_address, contact_no) VALUES
('B101','E301','Delhi','+911111111111'),
('B102','E302','Mumbai','+912222222222'),
('B103','E303','Bangalore','+913333333333');

INSERT INTO employees (emp_id, emp_name, position, salary, branch_id) VALUES
('E301','Rohit Khanna','Manager',75000,'B101'),
('E302','Anjali Desai','Manager',72000,'B102'),
('E303','Suresh Pillai','Manager',70000,'B103'),
('E304','Nitin Gupta','Clerk',45000,'B101'),
('E305','Priya Shah','Clerk',47000,'B101'),
('E306','Vikram Patel','Clerk',43000,'B102'),
('E307','Riya Malhotra','Clerk',42000,'B103');

INSERT INTO members (member_id, member_name, member_address, reg_date) VALUES
('C201','Amit Sharma','Delhi','2023-01-10'),
('C202','Neha Verma','Mumbai','2023-03-18'),
('C203','Rahul Mehta','Pune','2023-06-25'),
('C204','Sneha Iyer','Bangalore','2023-09-12'),
('C205','Arjun Rao','Hyderabad','2024-01-05'),
('C206','Pooja Nair','Kochi','2024-02-20'),
('C207','Kunal Singh','Jaipur','2024-04-10'),
('C208','Meera Joshi','Ahmedabad','2024-05-15');

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher) VALUES
('ISBN001','1984','Dystopian',6.5,'yes','George Orwell','Penguin'),
('ISBN002','Animal Farm','Classic',5.0,'yes','George Orwell','Penguin'),
('ISBN003','Sapiens','History',8.0,'yes','Yuval Noah Harari','Harper'),
('ISBN004','The Hobbit','Fantasy',7.0,'yes','J.R.R. Tolkien','Harper'),
('ISBN005','Dune','Sci-Fi',8.5,'yes','Frank Herbert','Ace'),
('ISBN006','The Alchemist','Fiction',4.5,'yes','Paulo Coelho','Harper'),
('ISBN007','The Road','Dystopian',7.0,'yes','Cormac McCarthy','Vintage'),
('ISBN008','Harry Potter','Fantasy',6.5,'yes','J.K. Rowling','Bloomsbury');

INSERT INTO issued_status
(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
-- Jan
('IS301','C201','1984','2024-01-05','ISBN001','E304'),
('IS302','C202','Animal Farm','2024-01-12','ISBN002','E305'),
-- Feb
('IS303','C201','Sapiens','2024-02-01','ISBN003','E304'),
('IS304','C203','The Hobbit','2024-02-10','ISBN004','E306'),
-- Mar
('IS305','C201','Dune','2024-03-03','ISBN005','E304'),
('IS306','C204','The Alchemist','2024-03-15','ISBN006','E307'),
-- Apr
('IS307','C202','Harry Potter','2024-04-05','ISBN008','E305'),
('IS308','C205','The Road','2024-04-20','ISBN007','E304'),
-- May
('IS309','C201','Animal Farm','2024-05-10','ISBN002','E304'),
('IS310','C206','1984','2024-05-18','ISBN001','E306'),
-- Jun
('IS311','C202','Sapiens','2024-06-02','ISBN003','E305'),
('IS312','C207','Dune','2024-06-25','ISBN005','E307'),
-- Jul
('IS313','C201','Harry Potter','2024-07-01','ISBN008','E304'),
('IS314','C208','The Hobbit','2024-07-12','ISBN004','E306'),
-- Aug
('IS315','C202','The Road','2024-08-05','ISBN007','E305');


INSERT INTO return_status (return_id, issued_id, return_date) VALUES
-- On time
('RS301','IS301','2024-01-25'),
('RS302','IS302','2024-01-30'),
('RS303','IS304','2024-03-01'),
-- Late
('RS304','IS303','2024-03-20'),
('RS305','IS305','2024-04-25'),
('RS306','IS307','2024-05-20'),
-- Very late
('RS307','IS309','2024-07-01')
-- Never returned (overdue)
-- IS308
-- IS310
-- IS311
-- IS312
-- IS313
-- IS314
-- IS315
;