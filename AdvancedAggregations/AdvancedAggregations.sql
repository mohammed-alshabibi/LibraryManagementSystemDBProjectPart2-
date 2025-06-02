--HAVING for Filtering Aggregates
SELECT B.Book_ID, B.Title, AVG(R.Rating) AS AvgRating, COUNT(R.Review_ID) AS ReviewCount
FROM Book B
JOIN Review R ON B.Book_ID = R.Book_ID
GROUP BY B.Book_ID, B.Title
HAVING COUNT(R.Review_ID) > 3 AND AVG(R.Rating) > 4;


--Subquery – Max Price Per Genre
SELECT Book_ID, Title, Genre, Price
FROM Book B
WHERE Price = (
    SELECT MAX(Price)
    FROM Book
    WHERE Genre = B.Genre
);


--Occupancy Rate Calculations
SELECT L.Library_ID, L.Name,
       CAST(SUM(CASE WHEN B.Availability_Status = 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS OccupancyRate
FROM Library L
JOIN Book B ON L.Library_ID = B.Library_ID
GROUP BY L.Library_ID, L.Name;


--Members with Loans but No Fine
SELECT DISTINCT M.Member_ID, M.Name
FROM Member M
JOIN Loan L ON M.Member_ID = L.Member_ID
LEFT JOIN Payment P ON L.Payment_ID = P.Payment_ID
WHERE P.Payment_ID IS NULL;

-- Insert a loan without linking a payment
INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
VALUES (3, 3, '2024-06-01', '2024-06-10', 'Issued');


--Genres with High Average Ratings
SELECT B.Genre, AVG(R.Rating) AS AvgGenreRating
FROM Book B
JOIN Review R ON B.Book_ID = R.Book_ID
GROUP BY B.Genre
HAVING AVG(R.Rating) > 4;
