/*
================================================================================
EXTRACTED SQL STATEMENTS CATALOG
================================================================================
Purpose: Comprehensive catalog of ALL SQL statements extracted from the 
         .NET application for Microsoft SQL Server to PostgreSQL migration
Date: 2026-01-01
Total Statements: 5
================================================================================
*/

-- ==============================================================================
-- STATEMENT 1: Update Author Using Stored Procedure
-- ==============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: 158
-- Method Context: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with Return Value
-- Transaction Context: No
-- Parameters:
--   @BusinessEntityID (int) - Author's business entity ID
--   @NationalIDNumber (string) - Author's national ID number
--   @BirthDate (DateTime) - Author's birth date (converted to UTC)
--   @MaritalStatus (string) - Author's marital status
--   @Gender (string) - Author's gender
-- Return: Number of rows affected
-- Notes: Uses DECLARE/EXEC pattern to capture return value from stored procedure
-- ==============================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 2: Select All Authors
-- ==============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: 184
-- Method Context: FindAllAuthorsEmbeddedSql
-- Statement Type: Direct SELECT Query
-- Transaction Context: No
-- Parameters: None
-- Return: List of Author objects
-- Notes: Queries all columns from author table using schema-qualified name
-- ==============================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ==============================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ==============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: 207
-- Method Context: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with Return Value
-- Transaction Context: No
-- Parameters:
--   @BusinessEntityID (int) - Author's business entity ID to delete
-- Return: Number of rows affected
-- Notes: Uses DECLARE/EXEC pattern to capture return value from stored procedure
-- ==============================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Calculated Fields
-- ==============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: 227
-- Method Context: SelectAuthorsByHireYear
-- Statement Type: SELECT Query with T-SQL Functions
-- Transaction Context: No
-- Parameters:
--   @HireDate (int) - Year to filter authors hired
-- Return: List of AuthorAgeResult objects with BusinessEntityID, FormattedModifiedDate, Age
-- T-SQL Functions Used:
--   - FORMAT: Formats ModifiedDate to 'yyyy-MM-dd HH:mm:ss' pattern
--   - DATEDIFF: Calculates age in years from BirthDate to current date
--   - GETDATE(): Returns current date/time
--   - DATEPART: Extracts year from HireDate for filtering
-- Notes: Contains multiple SQL Server specific functions requiring conversion
-- ==============================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ==============================================================================
-- STATEMENT 5: Get All Products Using Stored Procedure
-- ==============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Source Line: 31
-- Method Context: FindAllProducts
-- Statement Type: Stored Procedure Call (No Parameters)
-- Transaction Context: No
-- Parameters: None
-- Return: List of Product objects
-- Notes: Simple stored procedure execution without parameters or return value capture
-- ==============================================================================

EXEC [dbo].[uspGetProductData];

-- ==============================================================================
-- END OF EXTRACTED STATEMENTS
-- ==============================================================================
-- Summary Statistics:
--   Total Statements: 5
--   Stored Procedure Calls: 3 (Statements 1, 3, 5)
--   Direct SQL Queries: 2 (Statements 2, 4)
--   Parameterized Queries: 3 (Statements 1, 3, 4)
--   Statements with T-SQL Functions: 1 (Statement 4)
--   Statements in Transactions: 0
-- ==============================================================================
