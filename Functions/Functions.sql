-- Function: Get average rating for a book
CREATE FUNCTION GetBookAverageRating (@BookID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AvgRating FLOAT;
    SELECT @AvgRating = AVG(Rating) FROM Review WHERE Book_ID = @BookID;
    RETURN @AvgRating;
END;

-- Function: Get next available book
CREATE FUNCTION GetNextAvailableBook (@Genre VARCHAR(50), @Title NVARCHAR(100), @LibraryID INT)
RETURNS INT
AS
BEGIN
    DECLARE @BookID INT;
    SELECT TOP 1 @BookID = Book_ID
    FROM Book
    WHERE Genre = @Genre AND Title = @Title AND Library_ID = @LibraryID AND Availability_Status = 1;
    RETURN @BookID;
END;

-- Function: % of books currently issued
CREATE FUNCTION CalculateLibraryOccupancyRate (@LibraryID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Issued INT, @Total INT;
    SELECT @Issued = COUNT(*) FROM Book WHERE Library_ID = @LibraryID AND Availability_Status = 0;
    SELECT @Total = COUNT(*) FROM Book WHERE Library_ID = @LibraryID;
    RETURN CASE WHEN @Total = 0 THEN 0 ELSE (CAST(@Issued AS FLOAT) / @Total) * 100 END;
END;

-- Function: Total loans by member
CREATE FUNCTION fn_GetMemberLoanCount (@MemberID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM Loan WHERE Member_ID = @MemberID;
    RETURN @Count;
END;

-- Function: Late return days
CREATE FUNCTION fn_GetLateReturnDays (@LoanID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Days INT = 0;
    SELECT @Days = DATEDIFF(DAY, Due_Date, Return_Date)
    FROM Loan
    WHERE Loan_ID = @LoanID AND Return_Date > Due_Date;
    RETURN ISNULL(@Days, 0);
END;

-- Function: List available books from a library
CREATE FUNCTION fn_ListAvailableBooksByLibrary (@LibraryID INT)
RETURNS TABLE
AS
RETURN
    SELECT Book_ID, Title, Genre, Price
    FROM Book
    WHERE Library_ID = @LibraryID AND Availability_Status = 1;

-- Function: Get top rated books (avg rating ≥ 4.5)
CREATE FUNCTION fn_GetTopRatedBooks()
RETURNS TABLE
AS
RETURN
    SELECT Book_ID, AVG(Rating) AS AvgRating
    FROM Review
    GROUP BY Book_ID
    HAVING AVG(Rating) >= 4.5;

-- Function: Format member name
CREATE FUNCTION fn_FormatMemberName (@First NVARCHAR(50), @Last NVARCHAR(50))
RETURNS NVARCHAR(100)
AS
BEGIN
    RETURN (@Last + ', ' + @First);
END;

-- test the function
SELECT dbo.GetBookAverageRating(1) AS AvgRating;

SELECT dbo.GetNextAvailableBook('Fiction', 'Harry Potter', 2) AS NextAvailableBookID;

SELECT dbo.CalculateLibraryOccupancyRate(1) AS OccupancyRate;

SELECT dbo.fn_GetMemberLoanCount(1) AS LoanCount;

SELECT dbo.fn_GetLateReturnDays(3) AS LateDays;  

SELECT dbo.fn_FormatMemberName('Ahmed', 'Hassan') AS FullName;


