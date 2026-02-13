-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Source Application: Bob's Bookstore
-- Conversion Date: 2025-02-12
-- ============================================================================

-- This file contains all SQL statement pairs (original SQL Server and converted PostgreSQL)
-- Conversion Method: Manual (DMS tool failed for all statements)
-- See dms_conversion_log.txt for detailed conversion notes

-- ============================================================================
-- STATEMENT PAIR #1: Simple SELECT from Author Table
-- ============================================================================

-- SOURCE: SQL Server
-- Method: FindAllAuthorsEmbeddedSql()
-- File: AuthorsController.cs, Line ~194
SELECT * FROM bobsbookstore_dbo.author

-- TARGET: PostgreSQL
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Changes: None (already PostgreSQL compatible)
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT PAIR #2: Update Author Personal Info
-- ============================================================================

-- SOURCE: SQL Server
-- Method: EditUsingStoredProcedure()
-- File: AuthorsController.cs, Line ~164
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- TARGET: PostgreSQL
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Changes: Converted stored procedure call to direct UPDATE statement
-- Reason: PostgreSQL stored procedures have different syntax; direct SQL more reliable for ADO.NET
UPDATE bobsbookstore_dbo.author 
SET NationalIDNumber = $2, 
    BirthDate = $3, 
    MaritalStatus = $4, 
    Gender = $5, 
    ModifiedDate = CURRENT_TIMESTAMP 
WHERE BusinessEntityID = $1

-- ============================================================================
-- STATEMENT PAIR #3: Delete Author
-- ============================================================================

-- SOURCE: SQL Server
-- Method: DeleteAuthorEmbeddedSql()
-- File: AuthorsController.cs, Line ~212
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- TARGET: PostgreSQL
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Changes: Converted stored procedure call to direct DELETE statement
-- Reason: PostgreSQL stored procedures have different syntax; direct SQL more reliable for ADO.NET
DELETE FROM bobsbookstore_dbo.author WHERE BusinessEntityID = $1

-- ============================================================================
-- STATEMENT PAIR #4: Complex SELECT with Date Functions
-- ============================================================================

-- SOURCE: SQL Server
-- Method: SelectAuthorsByHireYear()
-- File: AuthorsController.cs, Line ~230
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- TARGET: PostgreSQL
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Changes: Converted SQL Server date functions to PostgreSQL equivalents
-- - FORMAT() -> TO_CHAR()
-- - DATEDIFF(YEAR, ...) -> EXTRACT(YEAR FROM AGE(...))
-- - GETDATE() -> CURRENT_DATE
-- - DATEPART(YEAR, ...) -> EXTRACT(YEAR FROM ...)
SELECT BusinessEntityID, 
       TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statement Pairs: 4
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- DMS Tool Status: Failed for all statements
-- DMS Error: Metadata model creation failed
-- 
-- Statements Ready for Equivalency Validation: 4
-- Statements Ready for Code Re-integration: 4
-- ============================================================================
