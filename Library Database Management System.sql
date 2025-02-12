CREATE TABLE Books (
    id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(MAX) NOT NULL,
    author NVARCHAR(MAX) NOT NULL,
    genre NVARCHAR(MAX) NOT NULL,
    publication_year INT NOT NULL,
    availability_status NVARCHAR(MAX) NOT NULL
);

CREATE TABLE Members (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(MAX) NOT NULL,
    contact_information NVARCHAR(MAX) NOT NULL,
    membership_type NVARCHAR(50) NOT NULL CHECK (membership_type IN ('Student', 'Teacher', 'Visitor')),
    registration_date DATE NOT NULL
);

CREATE TABLE MemberBook (
    id INT PRIMARY KEY IDENTITY(1,1),
    member_id INT NOT NULL FOREIGN KEY REFERENCES Members(id),
    book_id INT NOT NULL FOREIGN KEY REFERENCES Books(id),
    borrowing_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE
);

CREATE TABLE LibraryStaff (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(MAX) NOT NULL,
    contact_info NVARCHAR(MAX) NOT NULL,
    assigned_section NVARCHAR(MAX) NOT NULL,
    employment_date DATE NOT NULL
);

CREATE TABLE Categories (
    id BIGINT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(MAX) NOT NULL,
    description NVARCHAR(MAX)
);

CREATE TABLE Reservations (
    id INT PRIMARY KEY IDENTITY(1,1),
    member_id INT NOT NULL FOREIGN KEY REFERENCES Members(id),
    book_id INT NOT NULL FOREIGN KEY REFERENCES Books(id),
    reservation_date DATE NOT NULL,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('Pending', 'Cancelled', 'Completed'))
);

CREATE TABLE FinancialFines (
    id INT PRIMARY KEY IDENTITY(1,1),
    member_id INT NOT NULL FOREIGN KEY REFERENCES Members(id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_status NVARCHAR(50) NOT NULL CHECK (payment_status IN ('Paid', 'Unpaid'))
);




-- Insert into Books
INSERT INTO Books (title, author, genre, publication_year, availability_status) VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 'Available'),
('1984', 'George Orwell', 'Dystopian', 1949, 'Borrowed'),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 'Available'),
('Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 'Available'),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 'On Hold');

-- Insert into Members
INSERT INTO Members (name, contact_information, membership_type, registration_date) VALUES
('Alice Johnson', 'alice@email.com', 'Student', '2023-01-15'),
('Bob Smith', '555-1234', 'Teacher', '2022-05-20'),
('Charlie Brown', 'charlie@email.com', 'Visitor', '2023-03-10'),
('Diana Miller', '555-5678', 'Student', '2023-04-01'),
('Eva Green', 'eva@email.com', 'Visitor', '2023-02-28');

-- Insert into MemberBook
INSERT INTO MemberBook (member_id, book_id, borrowing_date, due_date, return_date) VALUES
(1, 2, '2023-10-01', '2023-10-15', NULL),
(2, 1, '2023-09-20', '2023-10-04', '2023-10-03'),
(3, 3, '2023-10-05', '2023-10-19', NULL),
(4, 5, '2023-09-25', '2023-10-09', '2023-10-08'),
(5, 4, '2023-10-02', '2023-10-16', NULL);

-- Insert into LibraryStaff
INSERT INTO LibraryStaff (name, contact_info, assigned_section, employment_date) VALUES
('John Doe', 'john@library.com', 'Reference', '2020-06-01'),
('Jane Smith', 'jane@library.com', 'Circulation', '2021-03-15'),
('Mike Brown', 'mike@library.com', 'Children''s Section', '2019-11-20'),
('Sarah Lee', 'sarah@library.com', 'IT Support', '2022-02-10'),
('Lucy Chen', 'lucy@library.com', 'Archives', '2023-01-05');

-- Insert into Categories
INSERT INTO Categories (name, description) VALUES
('Fiction', 'Imaginative narratives created from the author’s imagination'),
('Non-Fiction', 'Works based on real events and facts'),
('Science Fiction', 'Speculative fiction involving science/technology'),
('History', 'Analysis and interpretation of past events'),
('Romance', 'Stories focused on love relationships');

-- Insert into Reservations
INSERT INTO Reservations (member_id, book_id, reservation_date, status) VALUES
(1, 3, '2023-10-01', 'Completed'),
(2, 5, '2023-10-02', 'Pending'),
(3, 1, '2023-09-28', 'Cancelled'),
(4, 2, '2023-10-03', 'Pending'),
(5, 4, '2023-10-04', 'Completed');

-- Insert into FinancialFines
INSERT INTO FinancialFines (member_id, amount, payment_status) VALUES
(1, 5.00, 'Unpaid'),
(2, 10.50, 'Paid'),
(3, 2.00, 'Unpaid'),
(4, 7.75, 'Paid'),
(5, 3.25, 'Unpaid');


SELECT *
FROM Members
WHERE registration_date = '2023-01-15';   --q1


SELECT *
FROM Books
WHERE title = 'The Great Gatsby';   --q2


ALTER TABLE Members ADD Email VARCHAR(255);   --q3


INSERT INTO Members (name, contact_information, membership_type, registration_date , Email) VALUES
('Omar', '9876543210', 'Student', '5-6-2024' , 'Omar@gmail.com' );
SELECT * FROM Members    --q4


SELECT DISTINCT Members.id, Members.name, Members.contact_information, Members.membership_type, Members.registration_date
FROM Members
JOIN Reservations ON Members.id = Reservations.member_id;   --q5   Use DISTINCT to ensure that each member is listed only once, even if they have made multiple reservations.



SELECT Members.id, Members.name, Members.contact_information, Members.membership_type, Members.registration_date
FROM Members
JOIN MemberBook ON Members.id = MemberBook.member_id
JOIN Books ON MemberBook.book_id = Books.id
WHERE Books.title = 'The Hobbit';   --q6


select members.id, members.name, members.contact_information, members.membership_type, members.registration_date
from members
  join memberbook on members.id = memberbook.member_id
  join books on memberbook.book_id = books.id
where
  books.title = 'The Hobbit'
  and memberbook.return_date is not null;  --q7



SELECT Members.id, Members.name, Members.contact_information, Members.membership_type, Members.registration_date
FROM Members
JOIN MemberBook ON Members.id = MemberBook.member_id
WHERE MemberBook.return_date > MemberBook.due_date;   --q8





SELECT Books.id, Books.title, Books.author, Books.genre, Books.publication_year, Books.availability_status
FROM Books
JOIN MemberBook ON Books.id = MemberBook.book_id
GROUP BY Books.id, Books.title, Books.author, Books.genre, Books.publication_year, Books.availability_status
HAVING COUNT(MemberBook.id) > 3;     --q9



SELECT Members.id, Members.name, Members.contact_information, Members.membership_type, Members.registration_date
FROM Members
JOIN MemberBook ON Members.id = MemberBook.member_id
WHERE MemberBook.borrowing_date BETWEEN '2024-01-01' AND '2024-01-10';    --q10





SELECT COUNT(*) AS total_books
FROM Books
WHERE availability_status = 'Available';    --q11



SELECT Members.id, Members.name, Members.contact_information, Members.membership_type, Members.registration_date
FROM Members
JOIN MemberBook ON Members.id = MemberBook.member_id
WHERE MemberBook.return_date IS NULL;    --q12




SELECT DISTINCT Members.id, Members.name, Members.contact_information, Members.membership_type, Members.registration_date
FROM Members
JOIN MemberBook ON Members.id = MemberBook.member_id
JOIN Books ON MemberBook.book_id = Books.id
WHERE Books.genre = 'Fiction';       --q13











