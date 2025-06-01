-- Updates availability after issuing 
CREATE PROCEDURE sp_MarkBookUnavailable
    @BookID INT
AS
BEGIN
    UPDATE Book
    SET Availability_Status = 0
    WHERE Book_ID = @BookID;
END;

--Checks dates and updates loan statuses
CREATE PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    -- Mark overdue loans
    UPDATE Loan
    SET Status = 'Overdue'
    WHERE Status = 'Issued' AND Due_Date < GETDATE();

    -- Mark returned if Return_Date is set
    UPDATE Loan
    SET Status = 'Returned'
    WHERE Return_Date IS NOT NULL;
END;


--Ranks members by total fines paid 
CREATE PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SELECT M.Member_ID, M.Name, SUM(P.Amount) AS TotalFines
    FROM Member M
    JOIN Loan L ON M.Member_ID = L.Member_ID
    JOIN Payment P ON L.Payment_ID = P.Payment_ID
    GROUP BY M.Member_ID, M.Name
    ORDER BY TotalFines DESC;
END;

--===========================
--          TEST
--===========================

--Test sp_MarkBookUnavailable
-- Before: Check availability
SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;

-- Call the procedure
EXEC sp_MarkBookUnavailable @BookID = 1;

-- After: Check if updated
SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;


--Test sp_UpdateLoanStatus
-- View current loan statuses
SELECT Loan_ID, Status, Due_Date, Return_Date FROM Loan;

-- Run the procedure
EXEC sp_UpdateLoanStatus;

-- Check updated statuses
SELECT Loan_ID, Status, Due_Date, Return_Date FROM Loan;


--Test sp_RankMembersByFines
-- View ranking by fines
EXEC sp_RankMembersByFines;
