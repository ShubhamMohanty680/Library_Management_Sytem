SELECT * FROM library.`library branch`;
alter table books drop column ï»¿book_BookID;

show databases;
  
CREATE DATABASE Library;
use library;

ALTER TABLE authors RENAME COLUMN ï»¿book_authors_BookID to book_authors_BookID;

ALTER TABLE book_loans RENAME COLUMN ï»¿book_loans_BookID TO book_loans_BookID;

ALTER TABLE book_copies RENAME COLUMN  ï»¿book_copies_BookID TO book_copies_BookID;


-- Foreign key from tbl_book to tbl_publisher
ALTER TABLE books
ADD CONSTRAINT fk_book_publisher
FOREIGN KEY (book_PublisherName) REFERENCES publisher(publisher_PublisherName);

-- Foreign key from tbl_book_authors to tbl_book
ALTER TABLE authors
ADD CONSTRAINT fk_book_authors_book
FOREIGN KEY (book_authors_BookID) REFERENCES books(Book_ID);

-- Foreign key from tbl_book_copies to tbl_book
ALTER TABLE book_copies
ADD CONSTRAINT fk_book_copies_book
FOREIGN KEY (book_copies_BookID) REFERENCES books(Book_ID);

-- Foreign key from tbl_book_copies to tbl_library_branch
ALTER TABLE book_copies
ADD CONSTRAINT fk_book_copies_branch
FOREIGN KEY (book_copies_BranchID) REFERENCES library_branch(library_branch_BranchID);

-- Foreign key from tbl_book_loans to tbl_book
ALTER TABLE book_loans
ADD CONSTRAINT fk_book_loans_book
FOREIGN KEY (book_loans_BookID) REFERENCES books(Book_ID);

-- Foreign key from tbl_book_loans to tbl_library_branch
ALTER TABLE book_loans
ADD CONSTRAINT fk_book_loans_branch
FOREIGN KEY (book_loans_BranchID) REFERENCES library_branch(library_branch_BranchID);

-- Foreign key from tbl_book_loans to tbl_borrower
ALTER TABLE book_loans
ADD CONSTRAINT fk_book_loans_borrower_1
FOREIGN KEY (book_loans_CardNo) REFERENCES borrower(borrower_CardNo);




-- Q.1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT b.book_Title,lb.library_branch_BranchName, bc.book_copies_No_Of_Copies as Book_Copies FROM books b JOIN book_copies bc ON b.Book_ID=bc.book_copies_BookID JOIN library_branch lb ON bc.book_copies_BranchID=library_branch_BranchID
WHERE b.book_Title="The Lost Tribe" and lb.library_branch_BranchName="Sharpstown";

-- Q.2 How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT b.book_Title as `Book Title`,lb.library_branch_BranchName as `Library Branch` , bc.book_copies_No_Of_Copies as Book_Copies FROM books b JOIN book_copies bc ON b.Book_ID=bc.book_copies_BookID JOIN library_branch lb ON bc.book_copies_BranchID=library_branch_BranchID
WHERE b.book_Title="The Lost Tribe";

-- Q.3 Retrieve the names of all borrowers who do not have any books checked out.
SELECT b.borrower_BorrowerName
FROM borrower b
LEFT JOIN book_loans bl ON b.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_LoansID IS NULL;

-- Q.4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
SELECT b.book_Title as `Book Title`,br.borrower_BorrowerName as `Borrower Name`,br.borrower_BorrowerAddress as `Borrower Address`,bl.book_loans_DueDate as `Due Date`
FROM books b
JOIN book_loans bl ON b.Book_ID=bl.book_loans_BookID
JOIN library_branch lb ON bl.book_loans_BranchID=lb.library_branch_BranchID
JOIN borrower br ON bl.book_loans_CardNo=br.borrower_CardNo
WHERE lb.library_branch_BranchName="Sharpstown" and bl.book_loans_DueDate="2018-03-02"; 

-- Q.5 For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT lb.library_branch_BranchName as `Library Branch`,COUNT(bl.book_loans_BranchID) as `Total Number of Books Loaned` FROM 
book_loans bl JOIN library_branch lb 
ON bl.book_loans_BranchID=lb.library_branch_BranchID
GROUP BY lb.library_branch_BranchName;

-- Q.6 Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT b.borrower_BorrowerName,b.borrower_BorrowerAddress,COUNT(*) as Book_Count FROM
book_loans bl JOIN borrower b
ON bl.book_loans_CardNo=b.borrower_CardNo
GROUP BY b.borrower_CardNo
HAVING COUNT(*)>5;

-- Q.7 For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT a.book_authors_AuthorName as `Author Name`,b.book_Title as `Book Title`,book_copies_No_Of_Copies as `Copies Count`, lb.library_branch_BranchName FROM 
authors a JOIN books b
ON a.book_authors_BookID=b.Book_ID
JOIN book_copies bc ON b.Book_ID=bc.book_copies_BookID
JOIN library_branch lb ON bc.book_copies_BranchID=lb.library_branch_BranchID
WHERE a.book_authors_AuthorName="Stephen King" and lb.library_branch_BranchName="Central";

