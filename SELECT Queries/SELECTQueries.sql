--1. GET /loans/overdue -> List all overdue loans with member name, book title, due date  
SELECT L.Loan_ID, M.Name AS MemberName, B.Title AS BookTitle, L.Due_Date
FROM Loan L
JOIN Member M ON L.Member_ID = M.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID
WHERE L.Status = 'Overdue';

--2. GET /books/unavailable -> List books not available 
SELECT Book_ID, Title, ISBN
FROM Book
WHERE Availability_Status = 0; --All Availability_Status are 1, Do not have zero

--3. GET /members/top-borrowers → Members who borrowed >2 books 
SELECT M.Member_ID, M.Name, COUNT(*) AS BooksBorrowed
FROM Loan L
JOIN Member M ON L.Member_ID = M.Member_ID
GROUP BY M.Member_ID, M.Name
HAVING COUNT(*) > 2; -- I do not have member who borrowed >2

--4. GET /books/:id/ratings → Show average rating per book
SELECT Book_ID, AVG(Rating) AS AverageRating
FROM Review
GROUP BY Book_ID;

--5. GET /libraries/:id/genres → Count books by genre
SELECT Library_ID, Genre, COUNT(*) AS CountByGenre
FROM Book
GROUP BY Library_ID, Genre;

--6.  GET /members/inactive → List members with no loans  
SELECT M.*
FROM Member M
LEFT JOIN Loan L ON M.Member_ID = L.Member_ID
WHERE L.Loan_ID IS NULL;

--7. GET /payments/summary ->  Total fine paid per member  
SELECT M.Member_ID, M.Name, SUM(P.Amount) AS TotalFinesPaid
FROM Payment P
JOIN Loan L ON P.Payment_ID = L.Payment_ID
JOIN Member M ON L.Member_ID = M.Member_ID
GROUP BY M.Member_ID, M.Name;

--8. GET /reviews → Reviews with member and book info
SELECT R.Review_ID, M.Name AS MemberName, B.Title AS BookTitle, R.Comments, R.Rating
FROM Review R
JOIN Member M ON R.Member_ID = M.Member_ID
JOIN Book B ON R.Book_ID = B.Book_ID;

--9. GET /books/popular → List top 3 books by number of times they were loaned
SELECT TOP 3 B.Book_ID, B.Title, COUNT(*) AS LoanCount
FROM Loan L
JOIN Book B ON L.Book_ID = B.Book_ID
GROUP BY B.Book_ID, B.Title
ORDER BY LoanCount DESC;

--10. GET /members/:id/history → Retrieve full loan history of a specific member including book title, 
-- loan & return dates 
--DECLARE @MemberID INT = 1;  -- Replace 1 with the actual member ID you want
SELECT M.Name AS MemberName, B.Title AS BookTitle, L.Loan_Date, L.Return_Date
FROM Loan L
JOIN Member M ON L.Member_ID = M.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID
WHERE M.Member_ID = @MemberID;

--11. GET /books/:id/reviews → Show all reviews for a book with member name and comments 
Declare @BookID INT= 1;
SELECT R.Review_ID, M.Name AS MemberName, R.Comments, R.Rating, R.Review_Date
FROM Review R
JOIN Member M ON R.Member_ID = M.Member_ID
WHERE R.Book_ID = @BookID;


--12. GET /libraries/:id/staff → List all staff working in a given library
Declare @LibraryID INT= 1;
SELECT Staff_ID, Full_Name, Position, Contract
FROM Staff
WHERE Library_ID = @LibraryID;

--13. GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range 
Declare @MinPrice float = 25.00;
Declare @MaxPrice float = 40.00;

SELECT Book_ID, Title, Price
FROM Book
WHERE Price BETWEEN @MinPrice AND @MaxPrice;

--14. GET /loans/active → List all currently active loans (not yet returned) with member and book info
SELECT L.Loan_ID, M.Name AS MemberName, B.Title AS BookTitle, L.Loan_Date, L.Due_Date
FROM Loan L
JOIN Member M ON L.Member_ID = M.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID
WHERE L.Status = 'Issued';

--15. GET /members/with-fines → List members who have paid any fine
SELECT DISTINCT M.Member_ID, M.Name
FROM Loan L
JOIN Member M ON L.Member_ID = M.Member_ID
WHERE L.Payment_ID IS NOT NULL;

--16. GET /books/never-reviewed →  List books that have never been reviewed 
SELECT B.Book_ID, B.Title
FROM Book B
LEFT JOIN Review R ON B.Book_ID = R.Book_ID
WHERE R.Book_ID IS NULL;

--17. GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status. 
DECLARE @MemberID INT = 1;  
SELECT B.Title, L.Status, L.Loan_Date, L.Return_Date
FROM Loan L
JOIN Book B ON L.Book_ID = B.Book_ID
WHERE L.Member_ID = @MemberID;

--18. GET /members/inactive →List all members who have never borrowed any book. 
SELECT M.Member_ID, M.Name
FROM Member M
LEFT JOIN Loan L ON M.Member_ID = L.Member_ID
WHERE L.Member_ID IS NULL;

--19. GET /books/never-loaned
SELECT B.Book_ID, B.Title
FROM Book B
LEFT JOIN Loan L ON B.Book_ID = L.Book_ID
WHERE L.Book_ID IS NULL;

--20. GET /payments
SELECT P.Payment_ID, P.Date, P.Amount, M.Name AS MemberName, B.Title AS BookTitle
FROM Payment P
JOIN Loan L ON P.Payment_ID = L.Payment_ID
JOIN Member M ON L.Member_ID = M.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID;

--21. GET /loans/overdue→ List all overdue loans with member and book details.
SELECT L.Loan_ID, M.Name AS MemberName, B.Title AS BookTitle, L.Due_Date
FROM Loan L
JOIN Member M ON L.Member_ID = M.Member_ID
JOIN Book B ON L.Book_ID = B.Book_ID
WHERE L.Status = 'Overdue';

--22. GET /books/:id/loan-count → Show how many times a book has been loaned. 
Declare @BookID2 INT= 1;
SELECT Book_ID, COUNT(*) AS LoanCount
FROM Loan
WHERE Book_ID = @BookID2
GROUP BY Book_ID;

--23. GET /members/:id/fines → Get total fines paid by a member across all loans. 
SELECT M.Member_ID, M.Name, SUM(P.Amount) AS TotalFinesPaid
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
JOIN Payment P ON L.Payment_ID = P.Payment_ID
WHERE M.Member_ID = @MemberID
GROUP BY M.Member_ID, M.Name;


--24. GET /libraries/:id/book-stats → Show count of available and unavailable books in a library. 
SELECT Library_ID,
       COUNT(CASE WHEN Availability_Status = 1 THEN 1 END) AS AvailableBooks,
       COUNT(CASE WHEN Availability_Status = 0 THEN 1 END) AS UnavailableBooks
FROM Book
WHERE Library_ID = @LibraryID
GROUP BY Library_ID;


--25. GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5. 
SELECT B.Book_ID, B.Title, AVG(R.Rating) AS AvgRating, COUNT(R.Review_ID) AS ReviewCount
FROM Review R
JOIN Book B ON R.Book_ID = B.Book_ID
GROUP BY B.Book_ID, B.Title
HAVING COUNT(R.Review_ID) > 5 AND AVG(R.Rating) > 4.5;





