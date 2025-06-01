-- ===============================
-- Library Table Indexes
-- ===============================
CREATE NONCLUSTERED INDEX IX_Library_Name
ON Library(Name);

CREATE NONCLUSTERED INDEX IX_Library_Location
ON Library(Location);

-- ===============================
-- Book Table Indexes
-- ===============================

CREATE NONCLUSTERED INDEX IX_Book_LibraryID_ISBN
ON Book(Library_ID, ISBN);

CREATE NONCLUSTERED INDEX IX_Book_Genre
ON Book(Genre);

-- ===============================
-- Loan Table Indexes
-- ===============================

CREATE NONCLUSTERED INDEX IX_Loan_MemberID
ON Loan(Member_ID);

CREATE NONCLUSTERED INDEX IX_Loan_Status
ON Loan(Status);

CREATE NONCLUSTERED INDEX IX_Loan_BookID_LoanDate_ReturnDate
ON Loan(Book_ID, Loan_Date, Return_Date);
