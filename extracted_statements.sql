-- ========================================================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Purpose: Comprehensive catalog of all original SQL Server statements from BobsBookstore application
-- Created: Step 1 - SQL Statement Extraction Phase
-- Total Statements: 4
-- ========================================================================================================

-- ========================================================================================================
-- STATEMENT 1: UPDATE Author Personal Info via Stored Procedure
-- ========================================================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: 159
-- Type: Stored Procedure Call with DECLARE and EXEC
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Updates author personal information using SQL Server stored procedure uspUpdateAuthorPersonalInfo
-- ========================================================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ========================================================================================================
-- STATEMENT 2: SELECT All Authors
-- ========================================================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: 183
-- Type: SELECT statement
-- Parameters: None
-- Description: Simple SELECT to retrieve all author records from bobsbookstore_dbo.author table
-- ========================================================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================================================
-- STATEMENT 3: DELETE Author via Stored Procedure
-- ========================================================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: 207
-- Type: Stored Procedure Call with DECLARE and EXEC
-- Parameters: @BusinessEntityID (int)
-- Description: Deletes author using SQL Server stored procedure uspDeleteAuthor
-- ========================================================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ========================================================================================================
-- STATEMENT 4: SELECT Authors by Hire Year with Date Functions
-- ========================================================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: 227
-- Type: SELECT with SQL Server functions (FORMAT, DATEDIFF, DATEPART, GETDATE)
-- Parameters: @HireDate (int - year value)
-- Description: Complex SELECT with SQL Server-specific date functions to format dates, calculate age, and filter by hire year
-- SQL Server Functions Used:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss'): Formats date to specific string format
--   - DATEDIFF(YEAR, BirthDate, GETDATE()): Calculates age in years from birth date to current date
--   - GETDATE(): Returns current date/time
--   - DATEPART(YEAR, HireDate): Extracts year part from hire date
-- ========================================================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- Total Statements Extracted: 4
-- Next Step: Convert each statement using DMS MCP tool (dms-mcp____statement_conversion_tool)
-- ========================================================================================================
