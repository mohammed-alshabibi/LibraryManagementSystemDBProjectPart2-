-- Total Fines per Member
SELECT M.Member_ID, M.Name, SUM(P.Amount) AS TotalFines
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
JOIN Payment P ON L.Payment_ID = P.Payment_ID
GROUP BY M.Member_ID, M.Name;


--Most Active Libraries (by Loan Count)
SELECT Lib.Library_ID, Lib.Name, COUNT(L.Loan_ID) AS LoanCount
FROM Library Lib
JOIN Book B ON Lib.Library_ID = B.Library_ID
JOIN Loan L ON B.Book_ID = L.Book_ID
GROUP BY Lib.Library_ID, Lib.Name
ORDER BY LoanCount DESC;

--Average Book Price per Genre
SELECT Genre, AVG(Price) AS AvgPrice
FROM Book
GROUP BY Genre;


--Top 3 Most Reviewed Books
SELECT TOP 3 B.Book_ID, B.Title, COUNT(R.Review_ID) AS ReviewCount
FROM Book B
JOIN Review R ON B.Book_ID = R.Book_ID
GROUP BY B.Book_ID, B.Title
ORDER BY ReviewCount DESC;


--Member Activity Summary (Loan Count + Fines Paid)
SELECT M.Member_ID, M.Name, COUNT(L.Loan_ID) AS Loans, SUM(P.Amount) AS TotalFines
FROM Member M
LEFT JOIN Loan L ON M.Member_ID = L.Member_ID
LEFT JOIN Payment P ON L.Payment_ID = P.Payment_ID
GROUP BY M.Member_ID, M.Name;


--