-- After a new loan is inserted, set the book’s availability to 0 (unavailable)
CREATE TRIGGER trg_UpdateBookAvailability
ON Loan
AFTER INSERT
AS
BEGIN
    UPDATE B
    SET B.Availability_Status = 0
    FROM Book B
    JOIN INSERTED I ON B.Book_ID = I.Book_ID;
END;


--add LibraryRevenue column
ALTER TABLE Library
ADD LibraryRevenue DECIMAL(10,2) DEFAULT 0;

-- After a new payment, update the LibraryRevenue in Library table
CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payment
AFTER INSERT
AS
BEGIN
    UPDATE L
    SET L.LibraryRevenue = L.LibraryRevenue + I.Amount
    FROM Library L
    JOIN Book B ON L.Library_ID = B.Library_ID
    JOIN Loan LO ON LO.Book_ID = B.Book_ID
    JOIN INSERTED I ON I.Payment_ID = LO.Payment_ID;
END;


--Prevent inserting a loan with a return date before the loan date
CREATE TRIGGER trg_LoanDateValidation
ON Loan
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM INSERTED
        WHERE Return_Date IS NOT NULL AND Return_Date < Loan_Date
    )
    BEGIN
        RAISERROR('Return date cannot be before loan date.', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status)
        SELECT Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status
        FROM INSERTED;
    END
END;


-- ========== TEST: Trigger trg_UpdateBookAvailability ==========
PRINT '--- Testing trg_UpdateBookAvailability ---';
INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Status)
VALUES (1, 1, 1, '2024-06-01', '2024-06-10', 'Issued');
SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;

-- ========== TEST: Trigger trg_CalculateLibraryRevenue ==========
PRINT '--- Testing trg_CalculateLibraryRevenue ---';
-- Add a new payment linked to a loan
INSERT INTO Payment (Date, Amount, Method_ID)
VALUES ('2024-06-01', 20.00, 1);
-- Check updated revenue
SELECT Library_ID, Name, LibraryRevenue FROM Library;

-- ========== TEST: Trigger trg_LoanDateValidation ==========
PRINT '--- Testing trg_LoanDateValidation ---';
-- This insert should fail (invalid return date)
BEGIN TRY
    INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status)
    VALUES (2, 2, 2, '2024-06-10', '2024-06-15', '2024-06-05', 'Returned');
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

-- This one should succeed
INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status)
VALUES (2, 2, 2, '2024-06-01', '2024-06-10', '2024-06-09', 'Returned');
SELECT Loan_ID, Book_ID, Member_ID, Return_Date FROM Loan WHERE Book_ID = 2;

