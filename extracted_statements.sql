-- ====================================================================================
-- SQL STATEMENTS EXTRACTION CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- ====================================================================================
-- This file contains all extracted SQL statements from the BobsBookstore application
-- Each statement is documented with:
--   - Statement ID for tracking
--   - Source file and location (line numbers)
--   - Method name where the statement appears
--   - Complete SQL text
--   - Statement type
--   - Parameters used
-- ====================================================================================

-- ====================================================================================
-- STATEMENT 1
-- ====================================================================================
-- Statement ID: STMT_001
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 164
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Calls stored procedure uspUpdateAuthorPersonalInfo to update author personal information

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ====================================================================================
-- STATEMENT 2
-- ====================================================================================
-- Statement ID: STMT_002
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 192
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Inline SELECT Query
-- Parameters: None
-- Description: Retrieves all authors from the author table

SELECT * FROM bobsbookstore_dbo.author;

-- ====================================================================================
-- STATEMENT 3
-- ====================================================================================
-- Statement ID: STMT_003
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 209
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int)
-- Description: Calls stored procedure uspDeleteAuthor to delete an author

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ====================================================================================
-- STATEMENT 4
-- ====================================================================================
-- Statement ID: STMT_004
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 229
-- Method: SelectAuthorsByHireYear
-- Statement Type: Inline SELECT Query with SQL Server-Specific Functions
-- Parameters: @HireDate (int - year)
-- Description: Selects authors by hire year with formatted date, age calculation using FORMAT, DATEDIFF, GETDATE, and DATEPART functions

SELECT 
    BusinessEntityID, 
    FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ====================================================================================
-- SUMMARY
-- ====================================================================================
-- Total Statements Extracted: 4
-- Statement Types:
--   - Stored Procedure Calls: 2 (STMT_001, STMT_003)
--   - Inline SELECT Queries: 2 (STMT_002, STMT_004)
-- SQL Server Specific Features Identified:
--   - DECLARE variable syntax
--   - EXEC stored procedure with output parameter assignment
--   - FORMAT function (not standard SQL)
--   - DATEDIFF function (different syntax in PostgreSQL)
--   - GETDATE() function (NOW() in PostgreSQL)
--   - DATEPART function (EXTRACT in PostgreSQL)
--   - Schema notation [dbo].[procedureName]
-- ====================================================================================
