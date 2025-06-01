-- View 1: Books with average rating > 4.5 and total loans
CREATE VIEW ViewPopularBooks AS
SELECT B.Book_ID, B.Title, AVG(R.Rating) AS AvgRating, COUNT(L.Loan_ID) AS TotalLoans
FROM Book B
LEFT JOIN Review R ON B.Book_ID = R.Book_ID
LEFT JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY B.Book_ID, B.Title
HAVING AVG(R.Rating) > 4.5;

-- View 2: Member loan count and total fines paid
CREATE VIEW ViewMemberLoanSummary AS
SELECT M.Member_ID, M.Name, COUNT(L.Loan_ID) AS LoanCount, SUM(P.Amount) AS TotalFines
FROM Member M
LEFT JOIN Loan L ON M.Member_ID = L.Member_ID
LEFT JOIN Payment P ON L.Payment_ID = P.Payment_ID
GROUP BY M.Member_ID, M.Name;

-- View 3: Available books grouped by genre, ordered by price
CREATE VIEW ViewAvailableBooks AS
SELECT TOP 100 PERCENT Genre, Title, Price
FROM Book
WHERE Availability_Status = 1
ORDER BY Genre, Price;

-- View 4: Loan stats (issued, returned, overdue) per library
CREATE VIEW ViewLoanStatusSummary AS
SELECT Lib.Library_ID, Lib.Name,
       SUM(CASE WHEN L.Status = 'Issued' THEN 1 ELSE 0 END) AS IssuedCount,
       SUM(CASE WHEN L.Status = 'Returned' THEN 1 ELSE 0 END) AS ReturnedCount,
       SUM(CASE WHEN L.Status = 'Overdue' THEN 1 ELSE 0 END) AS OverdueCount
FROM Library Lib
JOIN Book B ON Lib.Library_ID = B.Library_ID
JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY Lib.Library_ID, Lib.Name;

-- View 5: Payment info with member, book, and status
CREATE VIEW ViewPaymentOverview AS
SELECT P.Payment_ID, M.Name AS MemberName, B.Title AS BookTitle, P.Amount, L.Status
FROM Payment P
JOIN Loan L ON P.Payment_ID = L.Payment_ID
JOIN Member M ON L.Member_ID = M.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID;

-- Test the Views
SELECT * FROM ViewPopularBooks;
SELECT * FROM ViewMemberLoanSummary;
SELECT * FROM ViewAvailableBooks;
SELECT * FROM ViewLoanStatusSummary;
SELECT * FROM ViewPaymentOverview;


