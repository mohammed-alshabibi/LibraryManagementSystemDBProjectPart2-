
-- ===========================================
-- 8. Transactions – Ensuring Consistency
-- ===========================================

-- 1️⃣ Borrowing a Book (Loan insert + Update Availability)
BEGIN TRANSACTION;

BEGIN TRY
    -- Insert loan
    INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
    VALUES (1, 1, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    -- Update book availability
    UPDATE Book
    SET Availability_Status = 0
    WHERE Book_ID = 1;

    COMMIT;
    PRINT 'Book borrowed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Borrowing failed: ' + ERROR_MESSAGE();
END CATCH;


-- 2️⃣ Returning a Book (Update status, return date, availability)
BEGIN TRANSACTION;

BEGIN TRY
    -- Update loan record to returned
    UPDATE Loan
    SET Return_Date = GETDATE(), Status = 'Returned'
    WHERE Loan_ID = 1;

    -- Mark the book as available again
    UPDATE Book
    SET Availability_Status = 1
    WHERE Book_ID = (SELECT Book_ID FROM Loan WHERE Loan_ID = 1);

    COMMIT;
    PRINT ' Book returned successfully.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ' Return failed: ' + ERROR_MESSAGE();
END CATCH;


-- 3️⃣ Registering a Payment (with validation)
BEGIN TRANSACTION;

BEGIN TRY
    DECLARE @Amount DECIMAL(6,2) = 20.00;
    IF @Amount <= 0
        THROW 50000, ' Payment amount must be positive.', 1;

    -- Insert payment
    INSERT INTO Payment (Date, Amount, Method_ID)
    VALUES (GETDATE(), @Amount, 1);

    COMMIT;
    PRINT ' Payment registered.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;


-- 4️⃣ Batch Loan Insert (Rollback on failure)
BEGIN TRANSACTION;

BEGIN TRY
    -- Insert first loan
    INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
    VALUES (2, 2, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    -- Insert second loan
    INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
    VALUES (3, 3, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    COMMIT;
    PRINT ' Both loans inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ' Batch insert failed: ' + ERROR_MESSAGE();
END CATCH;
