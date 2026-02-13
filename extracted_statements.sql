-- ================================================================
-- SQL Server to PostgreSQL Migration - Extracted SQL Statements
-- ================================================================
-- Total Statements: 5
-- Extraction Date: 2026-02-13
-- ================================================================

-- ================================================================
-- STATEMENT 1
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Numbers: 165
-- Statement Type: Stored Procedure Call with Variable Declaration
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Executes stored procedure uspUpdateAuthorPersonalInfo to update author personal information
-- ================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;
-- ================================================================


-- ================================================================
-- STATEMENT 2
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Numbers: 183
-- Statement Type: SELECT query
-- Parameters: None
-- Description: Selects all authors from the bobsbookstore_dbo.author table
-- ================================================================
SELECT * FROM bobsbookstore_dbo.author
-- ================================================================


-- ================================================================
-- STATEMENT 3
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Numbers: 203
-- Statement Type: Stored Procedure Call with Variable Declaration
-- Parameters: @BusinessEntityID (int)
-- Description: Executes stored procedure uspDeleteAuthor to delete an author
-- ================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;
-- ================================================================


-- ================================================================
-- STATEMENT 4
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Numbers: 223
-- Statement Type: SELECT query with date functions
-- Parameters: @HireDate (int - year value)
-- Description: Selects authors by hire year with formatted modified date and calculated age
-- Date Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- ================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- ================================================================


-- ================================================================
-- STATEMENT 5
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Numbers: 31
-- Statement Type: Stored Procedure Call
-- Parameters: None
-- Description: Executes stored procedure uspGetProductData to retrieve all products
-- ================================================================
EXEC [dbo].[uspGetProductData];
-- ================================================================


-- ================================================================
-- END OF EXTRACTED STATEMENTS
-- ================================================================
-- Summary:
-- - Total Statements: 5
-- - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- - SELECT Queries: 2 (one simple, one with date functions)
-- - Files Analyzed: 2 (AuthorsController.cs, ProductsController.cs)
-- ================================================================
